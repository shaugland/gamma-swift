# SWIFT Taskbook
# Web Application for Task Management 

# web transaction objects
from bottle import request, response

# HTML request types
from bottle import route, get, put, post, delete, static_file

# web page template processor
from bottle import template

## development server
from bottle import run, default_app 

# ---------------------------
# web application routes
# ---------------------------

@route('/')
@route('/tasks')
@route('/home')
def tasks():
    return template("tasks.tpl") 

@route('/login')
def login():
    return template("login.tpl") 

@route('/register')
def login():
    return template("register.tpl") 

@route('/about')
def about():
    return template("about.tpl")



# ---------------------------
# task REST api 
# ---------------------------

import json
import dataset
import time

taskbook_db = dataset.connect('sqlite:///taskbook.db')  

@route('/settings')
def settings():
    settings_table = taskbook_db.get_table('settings')
    tasks = [dict(x) for x in settings_table.find()]
    return template("settings.tpl")

@get('/api/settings/get')
def get_settings():
    response.headers['Content-Type'] = 'application/json'
    response.headers['Cache-Control'] = 'no-cache'
    settings_table = taskbook_db.get_table('configSettings')
    settings = [dict(x) for x in settings_table.find()]
    return { "settings": settings }

@post('/api/settings')
def set_setting():
    data = request.json
    settings_table = taskbook_db.get_table('configSettings')
    settings_table.update(row=data, keys=['name'])
    return json.dumps({'status':200, 'success': True})


@get('/api/tasks')
def get_tasks():
    'return a list of tasks sorted by submit/modify time'
    response.headers['Content-Type'] = 'application/json'
    response.headers['Cache-Control'] = 'no-cache'
    task_table = taskbook_db.get_table('task')
    tasks = [dict(x) for x in task_table.find(order_by='time')]

    # also placing settings here since database works here
    settings = []
    try: 
        settings_table = taskbook_db.get_table('configSettings')
        settings = [dict(x) for x in settings_table.find(order_by='id')]
    except Exception as e:
        settings[0] = e
    return { "tasks": tasks, 'testingSettings': settings }

@post('/api/tasks')
def create_task():
    'create a new task in the database'
    try:
        data = request.json
        for key in data.keys():
            assert key in ["description","list", "completeBy", "tag", "tagColor", "taskColor"], f"Illegal key '{key}'"
        assert type(data['description']) is str, "Description is not a string."
        assert len(data['description'].strip()) > 0, "Description is length zero."
        assert type(data['tag']) is str, "Tag is not a string."
        assert data['list'] in ["today","tomorrow", "someday"], "List must be 'today' or 'tomorrow'"
    except Exception as e:
        response.status="400 Bad Request:"+str(e)
        return
    try:
        task_table = taskbook_db.get_table('task')
        task_table.insert({
            "time": time.time(),
            "description":data['description'].strip(),
            "list":data['list'].strip(),
            "completeBy":data['completeBy'],
            "tag":data['tag'].strip(),
            "tagColor":data['tagColor'].strip(),
            "taskColor":data['taskColor'].strip(),
            "completed":False
        })
    except Exception as e:
        response.status="409 Bad Request:"+str(e)
    # return 200 Success
    response.headers['Content-Type'] = 'application/json'
    return json.dumps({'status':200, 'success': True})

@put('/api/tasks')
def update_task():
    'update properties of an existing task in the database'
    try:
        data = request.json
        for key in data.keys():
            assert key in ["id","description","completed","list", "completeBy", "tag", "tagColor", "taskColor"], f"Illegal key '{key}'"
        assert type(data['id']) is int, f"id '{id}' is not int"
        if "description" in request:
            assert type(data['description']) is str, "Description is not a string."
            assert len(data['description'].strip()) > 0, "Description is length zero."
        if "completed" in request:
            assert type(data['completed']) is bool, "Completed is not a bool."
        if "list" in request:
            assert data['list'] in ["today","tomorrow", "someday"], "List must be 'today' or 'tomorrow'"
        if "tag" in request:
            assert type(data['tag']) is str, "Tag is not string."
    except Exception as e:
        response.status="400 Bad Request:"+str(e)
        return
    if 'list' in data: 
        data['time'] = time.time()
    try:
        task_table = taskbook_db.get_table('task')
        task_table.update(row=data, keys=['id'])
    except Exception as e:
        response.status="409 Bad Request:"+str(e)
        return
    # return 200 Success
    response.headers['Content-Type'] = 'application/json'
    return json.dumps({'status':200, 'success': True})

@delete('/api/tasks')
def delete_task():
    'delete an existing task in the database'
    try:
        data = request.json
        assert type(data['id']) is int, f"id '{id}' is not int"
    except Exception as e:
        response.status="400 Bad Request:"+str(e)
        return
    try:
        task_table = taskbook_db.get_table('task')
        task_table.delete(id=data['id'])
    except Exception as e:
        response.status="409 Bad Request:"+str(e)
        return
    # return 200 Success
    response.headers['Content-Type'] = 'application/json'
    return json.dumps({'success': True})

@route("/static/<filepath:path>")
def mp3(filepath):
    return static_file(filepath, root="static")

application = default_app()
if __name__ == "__main__":

    run(host='0.0.0.0', port=8080, debug=True)
