import os
import markdown
from weasyprint import HTML, CSS

REPORTS_DIR = "reports"
MD_FILE = os.path.join(REPORTS_DIR, "Feasibility_Report.md")
PDF_FILE = os.path.join(REPORTS_DIR, "Feasibility_Report.pdf")

def convert_md_to_pdf():
    if not os.path.exists(MD_FILE):
        print(f"[!] Không tìm thấy file {MD_FILE}")
        return

    with open(MD_FILE, "r", encoding="utf-8") as f:
        md_content = f.read()

    # Chuyển đổi Markdown sang HTML
    html_content = markdown.markdown(md_content, extensions=['tables', 'fenced_code'])

    # CSS định dạng trang in học thuật chuẩn A4
    custom_css = CSS(string="""
        @page {
            size: A4;
            margin: 20mm 15mm 20mm 15mm;
            @bottom-right {
                content: counter(page);
                font-size: 9pt;
            }
        }
        body {
            font-family: 'Times New Roman', serif;
            font-size: 11pt;
            line-height: 1.5;
            color: #111;
        }
        h1 { font-size: 16pt; text-align: center; font-weight: bold; margin-bottom: 20px; }
        h2 { font-size: 13pt; text-align: center; margin-bottom: 25px; }
        h3 { font-size: 12pt; font-weight: bold; margin-top: 15px; border-bottom: 1px solid #333; padding-bottom: 3px; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
            font-size: 9.5pt;
        }
        th, td {
            border: 1px solid #444;
            padding: 6px 8px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        code {
            background-color: #f5f5f5;
            padding: 2px 4px;
            font-family: monospace;
            font-size: 9pt;
        }
    """)

    HTML(string=html_content).write_pdf(PDF_FILE, stylesheets=[custom_css])
    print(f"[SUCCESS] Đã tạo thành công báo cáo PDF tại: {PDF_FILE}")

if __name__ == "__main__":
    convert_md_to_pdf()