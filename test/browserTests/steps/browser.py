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
    context.browser.find_element_by_xpath("//option[@value='" + day + "']").click()

    search_element = context.browser.find_element_by_id('input-editor')
    search_element.clear()
    search_element.send_keys(taskName)
    context.browser.find_element_by_id('save_edit-editor').click()
    context.task_name = taskName

@then(u'there should be one more task added')
def step_impl(context):
    count = 0
    spans = list(context.browser.find_elements_by_tag_name('span'))
    for span in spans:
        if context.task_name in span.text:
            count = count + 1

    assert count > 0

    context.browser.close()

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
    context.browser.close()

@when(u'we edit a task')
def step_impl(context):
    element = context.browser.find_elements_by_class_name('edit_task')[0]
    element.click()
    edit_num = element.get_property('id')[10:]
    edit_input = context.browser.find_element_by_id('input-'+edit_num)
    edit_input.clear()
    edit_input.send_keys('edit a task')

    context.browser.find_element_by_id('save_edit-'+edit_num).click()

@then(u'the task should be different')
def step_impl(context):
    count = 0
    spans = list(context.browser.find_elements_by_tag_name('span'))
    for span in spans:
        if 'edit a task' in span.text:
            count = count + 1
    
    assert count > 0

    context.browser.close()

def after_all(context):
    context.browser.close()