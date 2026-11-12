"""Play Store phone screenshots for عمالي.

Composites real app captures into 1080x1920 frames.
Headlines are written for the first glance in Arabic search:
attendance, bulk check-in, wages, job sites, projects, PDF reports.
"""

from pathlib import Path

import arabic_reshaper
from bidi.algorithm import get_display
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent
RAW = ROOT / "raw_screens"
OUT = ROOT / "play_mockups"
FONTS = ROOT / "fonts"
W, H = 1080, 1920
BG = (247, 244, 239)
INK = (15, 23, 42)
ORANGE = (232, 104, 31)
MUTED = (90, 102, 116)
FRAME = (17, 24, 39)

CONTENT_TOP = 105
CONTENT_BOT = 2294


def shape(text: str) -> str:
    return get_display(arabic_reshaper.reshape(text))


def font(weight: str, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(FONTS / f"Tajawal-{weight}.ttf"), size)


def fit_pair(lines, weight, start, max_width, minimum):
    size = start
    while size > minimum:
        f = font(weight, size)
        if all(f.getlength(shape(line)) <= max_width for line in lines):
            return f, size
        size -= 2
    return font(weight, minimum), minimum


SLIDES = [
    {
        "file": "10_attendance_summary.png",
        "out": "01_daily_attendance.png",
        "kicker": "حضور يومي",
        "title": ["حضور عمالك", "في نظرة واحدة"],
        "sub": "حاضر، غائب، وغير مسجّل",
        "anchor": "top",
    },
    {
        "file": "06_bulk_attendance.png",
        "out": "02_bulk_attendance.png",
        "kicker": "تسجيل جماعي",
        "title": ["سجّل الجميع", "بضغطة واحدة"],
        "sub": "اختر المكان وثبّت الحضور دفعة واحدة",
        "anchor": "bottom",
    },
    {
        "file": "09_attendance_record.png",
        "out": "03_wages_and_advances.png",
        "kicker": "الأجور والسلف",
        "title": ["حساب الأجر", "والسلف معاً"],
        "sub": "اليومية، المسحوب، والمتبقي لكل عامل",
        "anchor": "bottom",
    },
    {
        "file": "03_worker_attendance_and_worksite.png",
        "out": "04_worksite_overtime.png",
        "kicker": "مواقع العمل",
        "title": ["مكان العمل", "والوقت الإضافي"],
        "sub": "سجّل الموقع والسهر مع حضور اليوم",
        "anchor": "bottom",
    },
    {
        "file": "08_projects_and_worksites.png",
        "out": "05_projects.png",
        "kicker": "المشاريع",
        "title": ["ميزانية كل", "موقع عمل"],
        "sub": "أيام العمل والأجور والسلف في مكان واحد",
        "anchor": "top",
    },
    {
        "file": "07_monthly_reports.png",
        "out": "06_pdf_and_reminder.png",
        "kicker": "التقارير",
        "title": ["تقرير PDF", "وتنبيه يومي"],
        "sub": "صدّر الشهر واحفظ نسخة احتياطية",
        "anchor": "top",
    },
]


def build(slide):
    canvas = Image.new("RGBA", (W, H), BG + (255,))
    draw = ImageDraw.Draw(canvas)

    margin = 64
    max_text = W - margin * 2
    right = W - margin

    brand_font = font("Bold", 34)
    kicker_font = font("Medium", 30)
    title_font, title_size = fit_pair(slide["title"], "ExtraBold", 86, max_text, 60)
    sub_font, _ = fit_pair([slide["sub"]], "Medium", 34, max_text, 26)

    # Whole header stacks on the right, the way the screenshot is read.
    y = 52
    draw.text((right, y), shape("عمالي"), font=brand_font, fill=ORANGE, anchor="rt")
    y += 52
    draw.text((right, y), shape(slide["kicker"]), font=kicker_font, fill=MUTED, anchor="rt")
    y += 58
    line_gap = int(title_size * 1.18)
    for index, line in enumerate(slide["title"]):
        draw.text(
            (right, y),
            shape(line),
            font=title_font,
            fill=ORANGE if index == 1 else INK,
            anchor="rt",
        )
        y += line_gap
    y += 6
    draw.text((right, y), shape(slide["sub"]), font=sub_font, fill=MUTED, anchor="rt")
    sub_h = sub_font.getbbox(shape(slide["sub"]))[3]
    y += sub_h

    # Phone — large, bottom slightly inside the frame so the UI stays readable.
    phone_top = y + 56
    phone_side = 48
    phone_bottom = H - 36
    box = (phone_side, phone_top, W - phone_side, phone_bottom)
    radius = 64
    bezel = 16

    shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (box[0], box[1] + 22, box[2], box[3] + 18),
        radius=radius,
        fill=(15, 23, 42, 80),
    )
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(26)))

    frame = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(frame).rounded_rectangle(box, radius=radius, fill=FRAME + (255,))
    canvas.alpha_composite(frame)

    inner = (
        box[0] + bezel,
        box[1] + bezel,
        box[2] - bezel,
        box[3] - bezel,
    )
    inner_w = inner[2] - inner[0]
    inner_h = inner[3] - inner[1]
    src = Image.open(RAW / slide["file"]).convert("RGB")
    scale = inner_w / src.width
    window = int(round(inner_h / scale))
    if slide["anchor"] == "bottom":
        crop_top = max(CONTENT_TOP, CONTENT_BOT - window)
    else:
        crop_top = CONTENT_TOP
    crop_bot = min(src.height, crop_top + window)
    shot = src.crop((0, crop_top, src.width, crop_bot)).resize(
        (inner_w, inner_h), Image.Resampling.LANCZOS
    )

    screen_radius = radius - bezel
    mask = Image.new("L", (inner_w, inner_h), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, inner_w - 1, inner_h - 1), radius=screen_radius, fill=255
    )
    shot_rgba = shot.convert("RGBA")
    shot_rgba.putalpha(mask)
    canvas.alpha_composite(shot_rgba, (inner[0], inner[1]))

    OUT.mkdir(parents=True, exist_ok=True)
    rgb = Image.new("RGB", (W, H), BG)
    rgb.paste(canvas, mask=canvas.split()[-1])
    rgb.save(OUT / slide["out"], "PNG", optimize=True)
    print(slide["out"], "title", title_size, "crop", crop_top, crop_bot)


def contact_sheet():
    files = sorted(OUT.glob("0*.png"))
    thumb_w, thumb_h = 360, 640
    pad = 24
    sheet = Image.new("RGB", (thumb_w * 3 + pad * 4, thumb_h * 2 + pad * 3), (255, 255, 255))
    for i, path in enumerate(files):
        im = Image.open(path).resize((thumb_w, thumb_h), Image.Resampling.LANCZOS)
        col, row = i % 3, i // 3
        sheet.paste(im, (pad + col * (thumb_w + pad), pad + row * (thumb_h + pad)))
    sheet.save(OUT / "00_preview.png", "PNG", optimize=True)


def main():
    for slide in SLIDES:
        build(slide)
    contact_sheet()


if __name__ == "__main__":
    main()
