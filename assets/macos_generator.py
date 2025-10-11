import cairo
from PIL import Image
import io
import argparse
import os


def create_rounded_icon(size, corner_radius):
    surface = cairo.ImageSurface(cairo.FORMAT_ARGB32, size, size)
    ctx = cairo.Context(surface)

    def point(x, y, quadrant):
        if quadrant in ["topRight", "bottomRight"]:
            x = size - x * corner_radius
        else:
            x = x * corner_radius
        if quadrant in ["bottomLeft", "bottomRight"]:
            y = size - y * corner_radius
        else:
            y = y * corner_radius
        return x, y

    def add_curve(to, control1, control2, quadrant):
        to = point(*to, quadrant)
        control1 = point(*control1, quadrant)
        control2 = point(*control2, quadrant)
        ctx.curve_to(control1[0], control1[1], control2[0], control2[1], to[0], to[1])

    # Top Left
    ctx.move_to(*point(1.528665, 0.0, "topLeft"))
    ctx.line_to(*point(1.528665, 0.0, "topRight"))
    add_curve((0.63149379, 0.07491139), (1.08849296, 0.0), (0.86840694, 0.0), "topRight")
    ctx.line_to(*point(0.63149379, 0.07491139, "topRight"))
    add_curve((0.07491139, 0.63149379), (0.37282383, 0.16905956), (0.16905956, 0.37282383), "topRight")
    add_curve((0.0, 1.52866498), (0.0, 0.86840694), (0.0, 1.08849296), "topRight")

    # Top Right to Bottom Right
    ctx.line_to(*point(0.0, 1.528665, "bottomRight"))
    add_curve((0.07491139, 0.63149379), (0.0, 1.08849296), (0.0, 0.86840694), "bottomRight")
    ctx.line_to(*point(0.07491139, 0.63149379, "bottomRight"))
    add_curve((0.63149379, 0.07491139), (0.16905956, 0.37282383), (0.37282383, 0.16905956), "bottomRight")
    add_curve((1.52866498, 0.0), (0.86840694, 0.0), (1.08849296, 0.0), "bottomRight")

    # Bottom Right to Bottom Left
    ctx.line_to(*point(1.528665, 0.0, "bottomLeft"))
    add_curve((0.63149379, 0.07491139), (1.08849296, 0.0), (0.86840694, 0.0), "bottomLeft")
    ctx.line_to(*point(0.63149379, 0.07491139, "bottomLeft"))
    add_curve((0.07491139, 0.63149379), (0.37282383, 0.16905956), (0.16905956, 0.37282383), "bottomLeft")
    add_curve((0.0, 1.52866498), (0.0, 0.86840694), (0.0, 1.08849296), "bottomLeft")

    # Bottom Left to Top Left
    ctx.line_to(*point(0.0, 1.528665, "topLeft"))
    add_curve((0.07491139, 0.63149379), (0.0, 1.08849296), (0.0, 0.86840694), "topLeft")
    ctx.line_to(*point(0.07491139, 0.63149379, "topLeft"))
    add_curve((0.63149379, 0.07491139), (0.16905956, 0.37282383), (0.37282383, 0.16905956), "topLeft")
    add_curve((1.52866498, 0.0), (0.86840694, 0.0), (1.08849296, 0.0), "topLeft")

    ctx.close_path()
    ctx.set_source_rgb(1, 1, 1)
    ctx.fill()

    return surface


def apply_mask(image, mask_surface):
    buf = io.BytesIO()
    mask_surface.write_to_png(buf)
    buf.seek(0)
    mask = Image.open(buf).convert("L")

    image = image.resize(mask.size, Image.LANCZOS)
    output = Image.new("RGBA", image.size, (0, 0, 0, 0))
    output.paste(image, (0, 0), mask)
    return output


def generate_icon_sizes(original_image):
    sizes = [16, 32, 64, 128, 256, 512, 1024]
    icons = {}
    for size in sizes:
        corner_radius = size * 0.225  # Approximately 45% of half the width
        mask_surface = create_rounded_icon(size, corner_radius)
        icons[size] = apply_mask(original_image, mask_surface)
    return icons


def main():
    parser = argparse.ArgumentParser(description="Generate macOS app icons from an input image.")
    parser.add_argument("input_image", help="Path to the input image file")
    parser.add_argument(
        "-o", "--output", default=".", help="Output directory for generated icons (default: current directory)"
    )
    args = parser.parse_args()

    # Ensure output directory exists
    os.makedirs(args.output, exist_ok=True)

    original_image = Image.open(args.input_image)
    icons = generate_icon_sizes(original_image)
    for size, icon in icons.items():
        icon.save(os.path.join(args.output, f"icon_{size}x{size}.png"))
    print(f"Icon generation complete! Icons saved in {args.output}")


if __name__ == "__main__":
    main()
