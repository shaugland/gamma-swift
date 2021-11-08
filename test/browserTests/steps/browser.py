from behave import *
from selenium import webdriver
from selenium.webdriver.common.keys import Keys 
import time


@given(u'we have navigated to {url}')
def step_impl(context, url):
    browser = webdriver.Firefox()
    browser.get(url)
    context.browser = browser
    time.sleep(5)

@when(u'we add a task for {day} called "{taskName}"')
def step_impl(context, day, taskName):
    search_element = context.browser.find_element_by_id('input-'+day)
    search_element.clear()
    search_element.send_keys(taskName)
    context.browser.find_element_by_id('save_edit-'+day).click()
    context.task_name = taskName

@then(u'there should be one more task added')
def step_impl(context):
    count = 0
    spans = list(context.browser.find_elements_by_tag_name('span'))
    for span in spans:
        if context.task_name in span.text:
            count = count + 1

    assert count > 0

@when(u'we delete a task')
def step_impl(context):
    all_elements = context.browser.find_elements_by_class_name('delete_task')
    context.before_delete_number = len(list(all_elements))
    deleted_task = context.browser.find_elements_by_class_name('delete_task')[0]
    deleted_task.click()
    context.after_delete_number = len(context.browser.find_elements_by_class_name('delete_task'))

@then(u'there should no longer be a task')
def step_impl(context):
    assert context.before_delete_number == context.after_delete_number + 1

