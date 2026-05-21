FROM python:3.11-slim

# -------- Create working directory --------
WORKDIR /app

# -------- Install Flask --------
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# -------- Copy application specific files --------
COPY app.py /app/
COPY templates/ /app/templates

# -------- Expose port --------
EXPOSE 5000

# -------- Start Flask app --------
CMD ["python", "app.py"]