from behave import * 

import swift


#delete 
@given('we have imported swift library')
def step_impl(context):
    assert 'delete' in dir(swift)

@when('we ask to delete a task')
def step_impl(context):
    context.result[] = swift.delete(task)

 @then('we no longer have a task')   
 def step_impl(context):
     assert context.result == null 

#tag
@given('we have imported swift library')
def step_impl(context):
    assert 'tag' in dir(swift)

@when('we ask to tag a task')
def step_impl(context):
    context.result[] = swift.tag(task)

 @then('the task has a tag')   
 def step_impl(context):
     assert context.result == #important

#marking task off
@given('we have imported swift library')
def step_impl(context):
    assert 'strikethrough' in dir(swift)

@when('we have a task to be marked off')
def step_impl(context):
    context.result[] = swift.strikethrough(task)

 @then('the task is completed and marked out')   
 def step_impl(context):
     assert context.result == t


#categorize task
@given('we have imported swift library')
def step_impl(context):
    assert 'categorize' in dir(swift)

@when('we have a task to be categorized as tomorrow')
def step_impl(context):
    context.result[] = swift.categorize(task)

 @then('the task is categorized as tomorrow')   
 def step_impl(context):
     assert context.result == "tomorrow"


#time
@given('we have imported swift library')
def step_impl(context):
    assert 'timestamp' in dir(swift)

@when('we have a task to be timestamped')
def step_impl(context):
    context.result[] = swift.timestamp(task)

 @then('the task is categorized as tomorrow')   
 def step_impl(context):
     assert context.result == "1700"



#time edit
@given('we have imported swift library')
def step_impl(context):
    assert 'timestamp' in dir(swift)

@when('we have a task where the time needs changed')
def step_impl(context):
    context.result[] = swift.timestamp(task)

 @then('the time is changed')   
 def step_impl(context):
     assert context.result == "1800"


#sounds
@given('we have a website on python anywhere')
def step_impl(context):
    pass 

@when('we visit the site')
def step_impl(context):
    assert True is not False  

 @then('the sound is played')   
 def step_impl(context):
     assert context.failed is False 

#login
@given('I have a valid account')
def step_impl(context):
    pass

@when('we visit the site')
def step_impl(context):
    context.browser.get('http://sfhaugland1.pythonanywhere.com/')
    form = get_element(context.browser, tag='form')
    get_element(form, name="admin").send_keys('admin')
    form.submit()

 @then('the user is successfully logged in')   
 def step_impl(context):
     assert form.submit() = True 

#color
@given('we have imported swift library')
def step_impl(context):
    assert 'color' in dir(swift)

@when('we have a task to be colored as yellow')
def step_impl(context):
    context.result[] = swift.color(task)

 @then('the task is colored as yellow')   
 def step_impl(context):
     assert context.result == "yellow"

