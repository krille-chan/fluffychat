---
applyTo: "lib/pangea/course_plans/**,lib/pangea/course_creation/**,lib/pangea/course_chats/**"
---

# Course Plans — Client Design

Client-side loading, caching, and display of localized course content (plans, topics, activities, locations, media).

- **Choreo design doc**: [course-localization.instructions.md](../../../2-step-choreographer/.github/instructions/course-localization.instructions.md)
- **Activity system**: [conversation-activities.instructions.md](conversation-activities.instructions.md)

---

## 1. Data Flow Overview

```
CoursePlanModel (fetched first)
  ├── topicIds: List<String>  ─── fetchTopics() ───► CourseTopicModel[]
  │     ├── activityIds       ─── fetchActivities() ► ActivityPlanModel[]
  │     └── locationIds       ─── fetchLocations() ─► CourseLocationModel[]
  └── mediaIds: List<String>  ─── fetchMediaUrls() ► CourseMediaResponse
```

Each level returns **IDs only**; the next level is fetched in a separate HTTP call. This is intentional — each level has its own cache and can be loaded independently.

---

## 2. Loading Pattern — `CoursePlanProvider` Mixin

[`CoursePlanProvider`](../../lib/pangea/course_plans/courses/course_plan_builder.dart) is a mixin used by course pages (`CourseChatsPage`, `SelectedCoursePage`, `PublicCoursePreview`). It orchestrates the multi-step loading:

| Method | What it fetches | When called |
|--------|----------------|-------------|
| `loadCourse(courseId)` | Course plan + media URLs | On page init |
| `loadTopics()` | ALL topics for the course + location media | Immediately after `loadCourse` completes |
| `loadActivity(topicId)` | Activities for ONE topic | On-demand (user taps a topic) |
| `loadAllActivities()` | Activities for ALL topics in parallel | Called from `chat_details.dart` on the course settings tab — **this is the performance bottleneck** |

### Current loading sequences

**`CourseChatsPage`** (main course view):
```
1. loadCourse(id) → POST /choreo/course_plans/localize
2. loadTopics()   → POST /choreo/topics/localize (ALL topic IDs)
3. _loadTopicsMedia() → location media for each topic
```
Activities are NOT loaded here. They display only in the course settings tab.

**`ChatDetailsController._loadCourseInfo()`** (course settings/details tab):
```
1. loadCourse(id)
2. loadTopics()
3. loadAllActivities() ← loads ALL activities for ALL topics at once
```
This is the call path that creates CMS pressure. See [course-localization.instructions.md §5](../../../2-step-choreographer/.github/instructions/course-localization.instructions.md) for the full analysis.

---

## 3. Repos & Caching

Each content type has its own repo with `GetStorage`-backed caching (1-day TTL):

| Repo | Storage Key | Cache Check |
|------|------------|-------------|
| [`CoursePlansRepo`](../../lib/pangea/course_plans/courses/course_plans_repo.dart) | `"course_storage"` → `"${uuid}_${l1}"` | Single course only (TODO: batch) |
| [`CourseTopicRepo`](../../lib/pangea/course_plans/course_topics/course_topic_repo.dart) | `"course_topic_storage"` → `"${uuid}_${l1}"` | Checks cache first, fetches only missing topics |
| [`CourseActivityRepo`](../../lib/pangea/course_plans/course_activities/course_activity_repo.dart) | `"course_activity_storage"` → `"${id}_${l1}"` | Checks cache first, fetches only missing activities |
| `CourseLocationRepo` | `"course_location_storage"` | Locations for topics |
| `CourseLocationMediaRepo` | `"course_location_media_storage"` | Media URLs for locations |
| `CourseMediaRepo` | `"course_media_storage"` | Media URLs for course-level images |

### Deduplication

All repos use a `Completer`-based in-flight cache (`Map<String, Completer<T>>`) keyed by batch ID to prevent duplicate concurrent requests for the same data.

### Cache invalidation

`CoursePlansRepo.clearCache()` clears ALL six storage boxes. This is called when the global 1-day TTL expires (checked on next `get()`).

---

## 4. Models

### `CoursePlanModel`

Returned by `CoursePlansRepo.get()`. Contains:
- Course metadata (`title`, `description`, `targetLanguage`, `cefrLevel`, etc.)
- `topicIds: List<String>` — IDs only, not full topic objects
- `mediaIds: List<String>` — IDs only
- `loadedTopics` — reads from `CourseTopicRepo` cache synchronously
- `fetchTopics()` — async, calls choreo API for missing topics

### `CourseTopicModel`

Returned by `CourseTopicRepo.get()`. Contains:
- Topic metadata (`title`, `description`, `uuid`)
- `activityIds: List<String>` — IDs only
- `locationIds: List<String>` — IDs only
- `loadedActivities` — reads from `CourseActivityRepo` cache synchronously
- `fetchActivities()` — async, calls choreo API for missing activities

### `ActivityPlanModel`

Returned by `CourseActivityRepo.get()`. Full activity plan with all fields (title, description, learning_objective, instructions, topic, objective, roles, mode, etc.).

---

## 5. Key API Endpoints

| Client Call | Choreo Endpoint | What's Sent |
|-------------|----------------|-------------|
| `CoursePlansRepo.get()` | `POST /choreo/course_plans/localize` | 1 course ID + L1 |
| `CoursePlanModel.fetchTopics()` | `POST /choreo/topics/localize` | ALL topic IDs for the course + L1 |
| `CourseTopicModel.fetchActivities()` | `POST /choreo/activity_plan/localize` | ALL activity IDs for one topic + L1 |

---

## 6. Pages That Load Courses

| Page | Loading Behavior |
|------|-----------------|
| [`CourseChatsPage`](../../lib/pangea/course_chats/course_chats_page.dart) | `loadCourse()` then `loadTopics()` — shows course with topic list. No activities loaded. |
| [`ChatDetailsController`](../../lib/pages/chat_details/chat_details.dart) | `loadCourse()` then `loadTopics()` then **`loadAllActivities()`** — the only call site that eagerly loads all activities |
| [`SelectedCoursePage`](../../lib/pangea/course_creation/selected_course_page.dart) | `loadCourse()` then `loadTopics()` — course detail/preview |
| [`PublicCoursePreview`](../../lib/pangea/course_creation/public_course_preview.dart) | `loadCourse()` then `loadTopics()` — browsing public courses |

---

## 7. Topic Unlock Logic — `ActivitySummariesProvider`

[`ActivitySummariesProvider`](../../lib/pangea/course_plans/course_activities/activity_summaries_provider.dart) is a mixin that determines which topic is "active" for a user. Topics are sequential — a user must complete activities in topic N before topic N+1 unlocks.

### `currentTopicId()` logic

Iterates topics in order. For each topic:
1. Checks `activityListComplete` — requires ALL activities for the topic to be loaded
2. Calls `_hasCompletedTopic()` — checks if the user has archived enough activity sessions
3. Returns the first incomplete topic

### `_hasCompletedTopic()` dependency on activity data

The unlock heuristic counts "two-person activities" via `topic.loadedActivities.values.where((a) => a.req.numberOfParticipants <= 2).length`. This is the only reason all activities need to be loaded for unlock computation. If `numberOfParticipants` were available without loading full activity objects, `loadAllActivities()` could be eliminated from the page load path.

---

## 8. UI Display Pattern — `CourseSettings`

[`CourseSettings`](../../lib/pangea/course_settings/course_settings.dart) renders the course details tab:

- **All topics are displayed as a vertical list** — title, location pin, participant avatars
- **Locked topics** are dimmed with a lock icon — activities are NOT shown for locked topics
- **Unlocked topics** show activities in a **horizontal scrollable `TopicActivitiesList`** per topic
- **Activities** are rendered as `ActivitySuggestionCard` widgets

This means even for unlocked topics, only a subset of activity cards are visible at any given time (horizontal scroll). Loading all activities across all topics upfront is unnecessary for display purposes.

---

## Future Work

_(No linked issues yet.)_
