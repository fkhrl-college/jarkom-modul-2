#!/bin/sh

set -e

echo "Melakukan generate calendar app otomatis..."
echo

echo "Step-1: install python3"
echo
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apk update
apk add python3

echo
echo "Step-2: generate app..."
echo

mkdir -p /root/aplikasi
cat << 'EOF' > /root/aplikasi/program.py
import calendar
from datetime import datetime
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = 5000

class CalendarRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        now = datetime.now()
        year = now.year
        month = now.month

        cal = calendar.Calendar(firstweekday=6)
        month_days = cal.monthdayscalendar(year, month)
        month_name = calendar.month_name[month]

        html = \
        f"""
        <!doctype html>
        <html lang="en">
        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>{month_name} {year} - Calendar</title>
            <style>
                body {{
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
                    background-color: #f4f7f6;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                }}
                .calendar-container {{
                    background: #ffffff;
                    padding: 24px;
                    border-radius: 12px;
                    box-shadow: 0 4px 20px rgba(0,0,0,0.8);
                    width: 100%;
                    max-width: 500px;
                }}
                h2 {{
                    text-align: center;
                    color: #2c3e50;
                    margin-top: 0;
                    margin-bottom: 20px;
                }}
                table {{
                    width: 100%;
                    border-collapse: collapse;
                }}
                th {{
                    background-color: #3498db;
                    color: white;
                    font-weight: 600;
                    padding: 12px 0;
                    width: 14.28%;
                    border-radius: 4px;
                }}
                td {{
                    text-align: center;
                    padding: 16px 0;
                    color: #333;
                    font-size: 16px;
                    font-weight: 500;
                }}
                .today {{
                    background-color: #e8f4fd;
                    color: #3498db;
                    border-radius: 50%;
                    font-weight: bold;
                }}
                .empty {{
                    color: #ccc;
                }}
            </style>
        </head>
        <body>
            <div class="calendar-container">
                <h2>{month_name} {year}</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Sun</th>
                            <th>Mon</th>
                            <th>Tue</th>
                            <th>Wed</th>
                            <th>Thu</th>
                            <th>Fri</th>
                            <th>Sat</th>
                        </tr>
                    </thead>
                    <tbody>
        """
        for week in month_days:
            html += f"<tr>"
            for day in week:
                if day == 0:
                    html += f'<td class="empty">&bull;</td>'
                elif day == now.day:
                    html += f'<td class="today">{day}</td>'
                else:
                    html += f"<td>{day}</td>"
            html += f"</tr>"
        html += \
        f"""
                    </tbody>
                </table>
            </div>
        </body>
        </html>
        """
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(html.encode("utf-8"))

def run():
    server_address = ("", PORT)
    httpd = HTTPServer(server_address, CalendarRequestHandler)
    print(f"Server running at http://localhost:{PORT}")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")

if __name__ == "__main__":
    run()
EOF

echo "Setup berhasil, harap nyalakan ulang..."