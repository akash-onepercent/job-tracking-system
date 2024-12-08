from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
from bs4 import BeautifulSoup
import json
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

import sys

if len(sys.argv) > 1:
    company_search = sys.argv[1]
else:
    print(json.dumps({"error": "No company name provided"}))
    sys.exit(1)

driver = webdriver.Chrome()
driver.get('https://www.linkedin.com/login')
email_field = driver.find_element(By.ID, "username")
password_field = driver.find_element(By.ID, "password")

email_field.send_keys('db325505@gmail.com')
password_field.send_keys('lmstudio123')
password_field.send_keys(Keys.RETURN)           
time.sleep(5)

driver.get('https://www.linkedin.com/jobs/')

time.sleep(5)

job_title_search = "Software Engineering"
company_search = "SpaceX"

search_input = driver.find_element(By.XPATH, "//*[contains(@id, 'jobs-search-box-keyword-id-ember')]")
search_input.clear()
search_input.send_keys(job_title_search + " " + company_search)
search_input.send_keys(Keys.RETURN)

time.sleep(5)

raw_html = driver.page_source



soup = BeautifulSoup(raw_html, 'html.parser')


jobs = soup.find_all('li', {'class': 'ember-view'})
job = jobs[0]


title_tag = job.find('a', {'class': 'job-card-container__link'})
title = title_tag.find('span', {'aria-hidden': 'true'}).text.strip() if title_tag else "N/A"

company_tag = job.find('div', {'class': 'artdeco-entity-lockup__subtitle'})
company = company_tag.text.strip() if company_tag else "N/A"

post_date_tag = job.find('time')
post_date = post_date_tag['datetime'] if post_date_tag else "N/A"

apply_link = title_tag['href'] if title_tag and 'href' in title_tag.attrs else "N/A"



if apply_link != "N/A":
    job_url = f"https://www.linkedin.com{apply_link}" if apply_link.startswith('/') else apply_link
    driver.get(job_url)
    time.sleep(5)
    raw_html = driver.page_source
    soup = BeautifulSoup(raw_html, 'html.parser')
    job_details = soup.find('p', {'dir': 'ltr'})
    job_details = job_details.text.strip()



    external_apply_link = "N/A"

    apply_button = WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.ID, "ember674"))
    )
    current_window = driver.current_window_handle

    apply_button.click()


    WebDriverWait(driver, 10).until(EC.number_of_windows_to_be(2))

    new_window = [window for window in driver.window_handles if window != current_window][0]
    driver.switch_to.window(new_window)

    external_apply_link = driver.current_url

    print(f"External Apply Link: {external_apply_link}")

job_info = {'Title': title,
            'Company': company,
            'Post Date': post_date,
            'Apply Link': f"https://www.linkedin.com{apply_link}" if apply_link.startswith('/') else apply_link,
            'External Apply Link': external_apply_link,
            'Job Details': job_details
            }
print(json.dumps(job_info))
# with open('job_info.json', 'w') as json_file:
#     json.dump(job_info, json_file, indent=4)