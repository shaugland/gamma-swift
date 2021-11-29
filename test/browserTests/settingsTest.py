from behave import *
from selenium import webdriver
from selenium.webdriver.common.keys import Keys 
import time


@given(u'we have navigated to {url}')
def step_impl(context, url):
    browser = webdriver.Chrome()
    browser.get(url)
    context.browser = browser
    time.sleep(5)

@when(u'we change {settings} to "{soundOff}"')
def step_impl(context, day, soundOff):
    search_element = context.browser.find_element_tag_name('Settings').click()
    search_element = context.browser.find_element_by_type('checkbox').click()
    search_element = context.browser.find_element_by_id('submitButton').click()
    context.task_name = soundOff

@then(u'there should be no sound')
def step_impl(context):
    count = 0
    spans = list(context.browser.find_elements_by_tag_name('includeMusic'))
    for span in spans:
        if context.task_name in span.text:
            count = count + 1

    assert count > 0
