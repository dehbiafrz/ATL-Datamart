import os
import re
import io
import urllib.request
import requests
from bs4 import BeautifulSoup
from minio import Minio
import sys

def main():
    base_data_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow"
    local_file_paths = grab_data(base_data_url) + grab_last_month_data(base_data_url)
    write_data_to_minio(local_file_paths)

def grab_data(base_url):
    years = {"2023"}
    local_file_paths = []

    url = "https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")

    for link in soup.find_all("a", href=re.compile(fr'^{base_url}')):
        for year in years:
            if year in link["href"]:
                local_file_path = download_file(link["href"])
                local_file_paths.append(local_file_path)

    return local_file_paths

def grab_last_month_data(base_url):
    url = "https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")

    links_with_dates = {}
    for link in soup.find_all("a", href=re.compile(fr'^{base_url}')):
        date_match = re.search(r"(\d{4})-(\d{2})", link["href"])
        if date_match:
            year, month = map(int, date_match.groups())
            links_with_dates[link["href"]] = (year, month)

    latest_link = max(links_with_dates, key=links_with_dates.get)
    local_file_path = download_file(latest_link)

    return [local_file_path]

def download_file(link):
    file_name = link.split("/trip-data/")[-1]
    local_file_path = f"../../data/raw/{file_name}"
    urllib.request.urlretrieve(link, local_file_path)
    return local_file_path

def write_data_to_minio(local_file_paths):
    client = Minio(
        "localhost:9000",
        secure=False,
        access_key="minio",
        secret_key="minio123"
    )
    bucket = "nyc-taxi"

    if not client.bucket_exists(bucket):
        client.make_bucket(bucket)
    else:
        print("Bucket " + bucket + " already exists")

    for file_path in local_file_paths:
        file_name = os.path.basename(file_path)
        with open(file_path, "rb") as data:
            data_bytes = io.BytesIO(data.read())
            client.put_object(bucket, file_name, data_bytes, length=data_bytes.getbuffer().nbytes)

if __name__ == '__main__':
    sys.exit(main())
