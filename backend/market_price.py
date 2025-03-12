from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import UnexpectedAlertPresentException, NoAlertPresentException
from webdriver_manager.chrome import ChromeDriverManager
import time

def scrape_all_prices():
    chrome_options = Options()
    # chrome_options.add_argument("--headless")  # Uncomment for headless execution
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)

    nested_prices = {}

    try:
        driver.get("https://www.upkrishivipran.in")
        time.sleep(5)  # Allow the page to load

        # Step 1: Get all Janpad options
        janpad_dropdown = Select(driver.find_element(By.XPATH, "//*[@id='ddDistrict']"))
        janpad_options = [option.text for option in janpad_dropdown.options if option.text.strip() != ""]

        for janpad in janpad_options:
            janpad_dropdown = Select(driver.find_element(By.XPATH, "//*[@id='ddDistrict']"))
            janpad_dropdown.select_by_visible_text(janpad)
            time.sleep(1)

            mandi_dropdown = Select(driver.find_element(By.XPATH, "//*[@id='ddCenter']"))
            mandi_options = [option.text for option in mandi_dropdown.options if option.text.strip() != ""]

            nested_prices[janpad] = {}
            for mandi in mandi_options:
                mandi_dropdown = Select(driver.find_element(By.XPATH, "//*[@id='ddCenter']"))
                mandi_dropdown.select_by_visible_text(mandi)
                time.sleep(1)

                commodity_dropdown = Select(driver.find_element(By.XPATH, "//*[@id='ddlPhasal']"))
                commodity_options = [option.text for option in commodity_dropdown.options if option.text.strip() != ""]

                nested_prices[janpad][mandi] = {}
                for commodity in commodity_options:
                    commodity_dropdown = Select(driver.find_element(By.XPATH, "//*[@id='ddlPhasal']"))
                    commodity_dropdown.select_by_visible_text(commodity)
                    time.sleep(1)

                    submit_button = driver.find_element(By.XPATH, "//*[@id='ContentPlaceHolder1_UpdatePanel33']/input")
                    submit_button.click()
                    time.sleep(2)

                    # Handle potential alert
                    try:
                        alert = driver.switch_to.alert
                        print(f"Alert detected: {alert.text}")
                        alert.accept()
                        continue  # Skip this commodity if alert is shown
                    except NoAlertPresentException:
                        pass

                    crop_prices = {}
                    crop_names = driver.find_elements(By.XPATH, "//*[@id='tbldata']/tbody/tr/td[2]/span")
                    wholesale_prices = driver.find_elements(By.XPATH, "//*[@id='tbldata']/tbody/tr/td[3]/span")
                    folklore_prices = driver.find_elements(By.XPATH, "//*[@id='tbldata']/tbody/tr/td[4]/span")

                    for crop, wholesale, folklore in zip(crop_names, wholesale_prices, folklore_prices):
                        crop_prices[crop.text.strip()] = {
                            "Wholesale Price (Rs/Kuntal)": wholesale.text.strip(),
                            "Folklore Price (Rs/kg)": folklore.text.strip()
                        }

                    nested_prices[janpad][mandi][commodity] = crop_prices

    except Exception as e:
        print(f"Error occurred: {e}")
    finally:
        driver.quit()

    return nested_prices


# all_prices = scrape_all_prices()

# import pprint
# pprint.pprint(all_prices)
