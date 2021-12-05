import dataset

if __name__ == "__main__":
    taskbook_db = dataset.connect('sqlite:///taskbook.db')  
    task_table = taskbook_db.get_table('task')
    task_table.drop()
    task_table = taskbook_db.create_table('task')
    task_table.insert_many([
        {"time":0.0, "description":"Do something useful", "list":"today", "completed":True, "tag":"tagOne"},
        {"time":0.5, "description":"Do something fantastic", "list":"today", "completed":False, "tag":"tagTwo"},
        {"time":0.3, "description":"Do something remarkable", "list":"tomorrow", "completed":False, "tag":"tagThree"},
        {"time":0.7, "description":"Do something unusual", "list":"tomorrow", "completed":True, "tag":"tagFour"},
        {"time":0.7, "description":"Do a backflip", "list":"someday", "completed":False, "tag":"tagFive"},
        {"time":0.7, "description":"End world hunger", "list":"someday", "completed":True, "tag":"tagSix"}
    ]) 
    task_table = taskbook_db.get_table('settings')
    task_table.drop()
    task_table = taskbook_db.create_table('settings')
    task_table.insert_many([
        { 'name': 'includeMusic', 'value': 'true'},
        { 'name': 'includeTags', 'value': 'true'}
    ])
    #Pats attempt at login
    # user_table = taskbook_db.get_table('user')
    # user_table.drop()
    # user_table = taskbook_db.create_table('user')
    # user_table.insert_many([
    #     {"email":"hasthebestgoats@gmail.com", "fname":"Kit", "lname":"Boga", "pass":"tubs4sale"},
    #     {"email":"johndoe@askjeeves.com", "fname":"John", "lname":"Doe", "pass":"1234"}
    # ])
    # Attempt at sessions table
    # session_table = taskbook_db.get_table('session')
    # session_table.drop()
    # session_table = taskbook_db.create_table('session')
    # session_table.insert(dict(email = 'hasthebestgoats@gmail.com'))
    # session_table.insert(dict(email = 'johndoe@askjeeves.com'))
