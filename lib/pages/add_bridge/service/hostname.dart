String extractHostName(String fullUrl) {
  const String prefixToRemove = "https://";
  const String prefixToRemoveTwo = "matrix.";

  // Check if the string begins with "https://".
  if (fullUrl.startsWith(prefixToRemove)) {
    // replaceFirst to remove the prefix
    return fullUrl.replaceFirst(prefixToRemove, '');
  }

  // Check if the string begins with "matrix.".
  if (fullUrl.startsWith(prefixToRemoveTwo)) {
    // replaceFirst to remove the prefix
    return fullUrl.replaceFirst(prefixToRemoveTwo, '');
  }

  // If the prefix is not found, the string remains unchanged.
  return fullUrl;
}
