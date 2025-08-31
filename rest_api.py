from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
import datetime


app = Flask(__name__)
CORS(app)


# Database connection function
def get_connection():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="5back@2SL", 
            database="student",
            ssl_disabled = True
        )
        return conn
    except mysql.connector.Error as e:
        print("Error connecting to DB:", e)
        return None

# Initialize database tables
def init_db():
    conn = get_connection()
    if not conn:
        print("Failed to initialize database: Connection error")
        return
    
    cursor = conn.cursor()
    
    try:
        # Create questions table if it doesn't exist
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS questions (
                id INT AUTO_INCREMENT PRIMARY KEY,
                student_id INT NOT NULL,
                content TEXT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                status VARCHAR(20) DEFAULT 'pending'
            )
        """)
        
        # Check if teacher_id column exists in questions table
        cursor.execute("""
            SHOW COLUMNS FROM questions LIKE 'teacher_id'
        """)
        result = cursor.fetchone()
        
        # If teacher_id column doesn't exist, add it
        if not result:
            try:
                cursor.execute("""
                    ALTER TABLE questions ADD COLUMN teacher_id INT
                """)
                print("Added teacher_id column to questions table")
                conn.commit()
            except Exception as e:
                
                conn.rollback()
        
        # Create answers table if it doesn't exist
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS answers (
                id INT AUTO_INCREMENT PRIMARY KEY,
                question_id INT NOT NULL,
                teacher_id INT NOT NULL,
                content TEXT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (question_id) REFERENCES questions(id)
            )
        """)
        
        conn.commit()
        
    except Exception as e:
        
        conn.rollback()
    finally:
        cursor.close()
        conn.close()


init_db()

# Route for registration
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data['username']
    password = data['password']
    role = data.get('role', 'student')  # Default role if not provided
    
    conn = get_connection()
    if not conn:
        return jsonify({'status': 'error', 'message': 'Database connection failed'}), 500
    
    cursor = conn.cursor()
    try:
        cursor.execute(
            "INSERT INTO users (username, password, role) VALUES (%s, %s, %s)",
            (username, password, role)
        )
        conn.commit()

        id = cursor.lastrowid 

        if role == 'student':
         cursor.execute("""
            INSERT INTO student (user_id, student_name)
            VALUES (%s, %s)
        """, (id, username))
        elif role == 'teacher':
         cursor.execute("""
            INSERT INTO teachers (user_id, teacher_name)
            VALUES (%s, %s)
        """, (id, username))

        conn.commit()

        return jsonify({'status': 'success'})
    except mysql.connector.IntegrityError:
        return jsonify({'status': 'exists'})  # Username already exists
    except Exception as e:
        print("Error:", e)
        return jsonify({'status': 'error', 'message': str(e)})
    finally:
        cursor.close()
        conn.close()
# Route for login
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    # Check user
    cursor.execute("""
        SELECT id, username, password, role
        FROM users
        WHERE username = %s AND password = %s
    """, (username, password))

    user = cursor.fetchone()

    if not user:
        cursor.close()
        conn.close()
        return jsonify({"status": "error", "message": "Invalid credentials"}), 401

    # If role is student, also fetch student_id
    if user['role'] == 'student':
        cursor.execute("SELECT id_student FROM student WHERE user_id = %s", (user['id'],))
        student = cursor.fetchone()
        user['student_id'] = student['id_student'] if student else None

    # If role is teacher, also fetch teacher_id
    if user['role'] == 'teacher':
        cursor.execute("SELECT teacher_id FROM teachers WHERE user_id = %s", (user['id'],))
        teacher = cursor.fetchone()
        user['teacher_id'] = teacher['teacher_id'] if teacher else None

    cursor.close()
    conn.close()

    return jsonify({
        "status": "success",
        "role": user['role'],
        "username": user['username'],
        "user_id": user['id'],
        "student_id": user.get('student_id'),
        "teacher_id": user.get('teacher_id')
    }), 200

# Update profile info (username + bio)
@app.route('/api/update_profile', methods=['PUT'])
def update_profile():
    data = request.get_json()
    user_id = data.get("user_id")
    username = data.get("username")
    bio = data.get("bio")
    role = data.get("role")

    if not user_id or not username or not role:
        return jsonify({"status": "error", "message": "Missing required fields"}), 400

    conn = get_connection()
    cursor = conn.cursor()

    try:
        # Update username in users table
        cursor.execute("UPDATE users SET username=%s WHERE id=%s", (username, user_id))

        # Update bio in role-specific table
        if role == "student":
            cursor.execute("UPDATE student SET student_name=%s, bio=%s WHERE user_id=%s", (username, bio, user_id))
        elif role == "teacher":
            cursor.execute("UPDATE teachers SET teacher_name=%s, bio=%s WHERE user_id=%s", (username, bio, user_id))

        conn.commit()
        return jsonify({"status": "success", "message": "Profile updated"})
    except Exception as e:
        conn.rollback()
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Fetch profile info (username + bio)
@app.route('/api/profile/<int:user_id>', methods=['GET'])
def get_profile(user_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("SELECT username, role FROM users WHERE id=%s", (user_id,))
        user = cursor.fetchone()
        if not user:
            return jsonify({"status": "error", "message": "User not found"}), 404

        if user["role"] == "student":
            cursor.execute("SELECT bio FROM student WHERE user_id=%s", (user_id,))
        else:
            cursor.execute("SELECT bio FROM teachers WHERE user_id=%s", (user_id,))
        extra = cursor.fetchone()
        bio = extra["bio"] if extra else ""

        return jsonify({
            "status": "success",
            "username": user["username"],
            "role": user["role"],
            "bio": bio or ""
        })
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Change user password
@app.route('/api/change_password', methods=['PUT'])
def change_password():
    data = request.get_json()
    user_id = data.get("user_id")
    old_password = data.get("old_password")
    new_password = data.get("new_password")

    if not user_id or not old_password or not new_password:
        return jsonify({"status": "error", "message": "Missing required fields"}), 400

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        # Check if old password matches
        cursor.execute("SELECT password FROM users WHERE id=%s", (user_id,))
        user = cursor.fetchone()
        if not user or user["password"] != old_password:
            return jsonify({"status": "error", "message": "Old password is incorrect"}), 401

        # Update password
        cursor.execute("UPDATE users SET password=%s WHERE id=%s", (new_password, user_id))
        conn.commit()
        return jsonify({"status": "success", "message": "Password updated successfully"})
    except Exception as e:
        conn.rollback()
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


#Get the student_id from user_id
@app.get("/student/{user_id}")
def get_student_by_user_id(user_id: int):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    query = "SELECT id_student FROM student WHERE user_id = %s"
    cursor.execute(query, (user_id,))
    result = cursor.fetchone()

    cursor.close()
    conn.close()

    if not result:
        raise HTTPException(status_code=404, detail="Student not found")

    return {"id_student": result["id_student"]}

#Get students for teacher page
@app.route('/student', methods=['GET'])
def students():
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT id_student, student_name, class FROM student;")
        students = cursor.fetchall()

        cursor.close()
        conn.close()

        return jsonify(students)
    except Exception as e:
        return jsonify({"error": str(e)}), 500



# Get student ID by username
@app.route('/api/student/id', methods=['GET'])
def get_student_id():
    username = request.args.get('username')
    if not username:
        return jsonify({'status': 'error', 'message': 'Username parameter is required'}), 400
    
    conn = get_connection()
    if not conn:
        return jsonify({'status': 'error', 'message': 'Database connection failed'}), 500
    
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT s.user_id AS student_id
            FROM student s
            JOIN users u ON s.user_id = u.id
            WHERE u.username = %s
        """, (username,))
        student = cursor.fetchone()
        
        if not student:
            return jsonify({'status': 'error', 'message': 'Student not found'}), 404
        
        return jsonify({'student_id': student['student_id']})
    except Exception as e:
        
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()



# Get teacher ID by username
@app.route('/api/teacher/id', methods=['GET'])
def get_teacher_id():
    username = request.args.get('username')
    if not username:
        return jsonify({'status': 'error', 'message': 'Username parameter is required'}), 400
    
    conn = get_connection()
    if not conn:
        return jsonify({'status': 'error', 'message': 'Database connection failed'}), 500
    
    cursor = conn.cursor(dictionary=True)
    try:
        # Get user ID directly from users table
        cursor.execute("SELECT id FROM users WHERE username = %s AND role = 'teacher'", (username,))
        user = cursor.fetchone()
        
        if not user:
            return jsonify({'status': 'error', 'message': 'Teacher not found'}), 404
        
        return jsonify({'teacher_id': user['id']})
    except Exception as e:
        
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# ✅ Submit a question
@app.route('/api/questions', methods=['POST'])
def submit_question():
    data = request.json
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO questions (student_id, teacher_id, content)
        VALUES (%s, %s, %s)
    """, (data['student_id'], data['teacher_id'], data['content']))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({"message": "Question submitted successfully"})

# Teacher: Get all questions
@app.route('/api/questions', methods=['GET'])
def get_questions():
    conn = get_connection()
    if not conn:
        return jsonify({'status': 'error', 'message': 'Database connection failed'}), 500
    
    cursor = conn.cursor(dictionary=True)
    try:
        # Get all questions with student and teacher information
        cursor.execute("""
            SELECT q.id, q.student_id, q.content, q.created_at, q.status, q.teacher_id,
                   s.student_name, t.teacher_name
            FROM questions questions
            LEFT JOIN student s ON q.student_id = s.user_id
            LEFT JOIN teachers t ON q.teacher_id = t.user_id
            ORDER BY questions.created_at DESC
        """)
        
        questions = cursor.fetchall()
       
        
        # Format datetime for JSON serialization
        for q in questions:
            q['created_at'] = q['created_at'].strftime('%Y-%m-%d %H:%M:%S')
        
        return jsonify(questions)
    except Exception as e:
        
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# ✅ Submit an answer
@app.route('/api/answers', methods=['POST'])
def submit_answer():
    data = request.json
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO answers (question_id, teacher_id, content)
        VALUES (%s, %s, %s)
    """, (data['question_id'], data['teacher_id'], data['content']))
    cursor.execute("UPDATE questions SET status = 'answered' WHERE id = %s", (data['question_id'],))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({"message": "Answer submitted successfully"})


# Test endpoint to check answers for a question
@app.route('/api/test/answers/<int:question_id>', methods=['GET'])
def test_get_answers(question_id):
    conn = get_connection()
    if not conn:
        return jsonify({'status': 'error', 'message': 'Database connection failed'}), 500
    
    cursor = conn.cursor(dictionary=True)
    try:
        # Get the question
        cursor.execute("SELECT * FROM questions WHERE id = %s", (question_id,))
        question = cursor.fetchone()
        
        if not question:
            return jsonify({'status': 'error', 'message': 'Question not found'}), 404
        
        # Get the answer
        cursor.execute("""
            SELECT a.*, t.teacher_name 
            FROM answers a
            JOIN teachers t ON a.teacher_id = t.user_id
            WHERE a.question_id = %s
        """, (question_id,))
        answers = cursor.fetchall()
        
        # Format datetime for JSON serialization
        for a in answers:
            a['created_at'] = a['created_at'].strftime('%Y-%m-%d %H:%M:%S')
        
        return jsonify({
            'question': question,
            'answers': answers
        })
    except Exception as e:
    
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# ✅ Get questions for a student
@app.route('/api/questions/student/<int:student_id>', methods=['GET'])
def get_student_questions(student_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT q.id, q.content, q.status, q.created_at,
               a.content AS answer, a.created_at AS answered_at,
               t.teacher_name
        FROM questions q
        JOIN teachers t ON q.teacher_id = t.teacher_id
        LEFT JOIN answers a ON q.id = a.question_id
        WHERE q.student_id = %s
        ORDER BY q.created_at DESC
    """, (student_id,))
    questions = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(questions)

#Get Questions for relavent teacher
@app.route('/questions/teacher/<int:teacher_id>', methods=['GET'])
def get_teacher_questions(teacher_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT q.id, q.content, q.status, q.created_at,
               u.username AS student_name
        FROM questions q
        JOIN student s ON q.student_id = s.id_student   
        JOIN users u ON s.user_id = u.id
        WHERE q.teacher_id = %s
        ORDER BY q.created_at DESC
    """, (teacher_id,))
    questions = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(questions)


# Route to get all available classes
@app.route('/api/classes', methods=['GET'])
def get_classes():
    conn = get_connection()
    if not conn:
        return jsonify({'status': 'error', 'message': 'Database connection failed'}), 500
    
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT DISTINCT class FROM timetable ORDER BY class")
        classes = [row[0] for row in cursor.fetchall()]
        return jsonify(classes)
    except Exception as e:
        print("Error:", e)
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Route to get timetable for a specific class
@app.route('/api/timetable', methods=['GET'])
def get_timetable():
    class_name = request.args.get('class')
    if not class_name:
        return jsonify({'status': 'error', 'message': 'Class parameter is required'}), 400
    
    conn = get_connection()
    if not conn:
        return jsonify({'status': 'error', 'message': 'Database connection failed'}), 500
    
    cursor = conn.cursor()
    try:
        # Get timetable data
        cursor.execute("""
            SELECT day, time_slot, subject 
            FROM timetable 
            WHERE class = %s
            ORDER BY FIELD(day, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'),
                     time_slot
        """, (class_name,))
        
        rows = cursor.fetchall()
        
        # Format data for Flutter
        timetable = {}
        for row in rows:
            day, time_slot, subject = row
            if day not in timetable:
                timetable[day] = {}
            timetable[day][time_slot] = subject
        
        return jsonify(timetable)
    except Exception as e:
        print("Error:", e)
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Route to update a timetable entry
@app.route('/api/timetable/update', methods=['PUT'])
def update_timetable():
    data = request.get_json()
    class_name = data.get('class')
    day = data.get('day')
    time_slot = data.get('time_slot')
    subject = data.get('subject')
    
    # Validate input
    if not all([class_name, day, time_slot, subject]):
        return jsonify({'status': 'error', 'message': 'All fields are required'}), 400
    
    conn = get_connection()
    if not conn:
        return jsonify({'status': 'error', 'message': 'Database connection failed'}), 500
    
    cursor = conn.cursor()
    try:
        # Check if the entry exists
        cursor.execute(
            "SELECT id FROM timetable WHERE class = %s AND day = %s AND time_slot = %s",
            (class_name, day, time_slot)
        )
        existing_entry = cursor.fetchone()
        
        if existing_entry:
            # Update existing entry
            cursor.execute(
                "UPDATE timetable SET subject = %s WHERE class = %s AND day = %s AND time_slot = %s",
                (subject, class_name, day, time_slot)
            )
            action = "updated"
        else:
            # Insert new entry
            cursor.execute(
                "INSERT INTO timetable (class, day, time_slot, subject) VALUES (%s, %s, %s, %s)",
                (class_name, day, time_slot, subject)
            )
            action = "created"
        
        conn.commit()
        return jsonify({
            'status': 'success',
            'message': f'Timetable entry {action} successfully',
            'class': class_name,
            'day': day,
            'time_slot': time_slot,
            'subject': subject
        })
    except Exception as e:
        print("Error:", e)
        conn.rollback()
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Route to get user's timetable (based on their class)
@app.route('/api/my-timetable', methods=['GET'])
def get_my_timetable():
    # Get username from query parameters
    username = request.args.get('username')
    if not username:
        return jsonify({'status': 'error', 'message': 'Username parameter is required'}), 400
    
    conn = get_connection()
    if not conn:
        return jsonify({'status': 'error', 'message': 'Database connection failed'}), 500
    
    cursor = conn.cursor(dictionary=True)
    try:
        # First get the user's class
        cursor.execute("SELECT class FROM user_classes WHERE username = %s", (username,))
        user_class = cursor.fetchone()
        
        if not user_class:
            return jsonify({'status': 'error', 'message': 'User class not found'}), 404
        
        class_name = user_class['class']
        
        # Now get the timetable for that class
        cursor.execute("""
            SELECT day, time_slot, subject 
            FROM timetable 
            WHERE class = %s
            ORDER BY FIELD(day, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'),
                     time_slot
        """, (class_name,))
        
        rows = cursor.fetchall()
        
        # Format data
        timetable = {}
        for row in rows:
            day, time_slot, subject = row.values()
            if day not in timetable:
                timetable[day] = {}
            timetable[day][time_slot] = subject
        
        return jsonify({
            'class': class_name,
            'timetable': timetable
        })
    except Exception as e:
        print("Error:", e)
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Route to get today's schedule for a user
@app.route('/api/today-schedule', methods=['GET'])
def get_today_schedule():
    username = request.args.get('username')
    if not username:
        return jsonify({'status': 'error', 'message': 'Username parameter is required'}), 400
    
    # Get current day of week
    today = datetime.now().strftime('%A')
    
    conn = get_connection()
    if not conn:
        return jsonify({'status': 'error', 'message': 'Database connection failed'}), 500
    
    cursor = conn.cursor(dictionary=True)
    try:
        # Get user's class
        cursor.execute("SELECT class FROM user_classes WHERE username = %s", (username,))
        user_class = cursor.fetchone()
        
        if not user_class:
            return jsonify({'status': 'error', 'message': 'User class not found'}), 404
        
        class_name = user_class['class']
        
        # Get today's schedule
        cursor.execute("""
            SELECT time_slot, subject 
            FROM timetable 
            WHERE class = %s AND day = %s
            ORDER BY time_slot
        """, (class_name, today))
        
        rows = cursor.fetchall()
        
        # Format data
        schedule = {}
        for row in rows:
            time_slot = row['time_slot']
            subject = row['subject']
            schedule[time_slot] = subject
        
        return jsonify({
            'day': today,
            'schedule': schedule
        })
    except Exception as e:
        print("Error:", e)
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

#Get Progress Reports.
@app.route("/progress_reports/<int:student_id>", methods=["GET"])
def get_progress_reports(student_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT id, term, remarks, DATE_FORMAT(date, '%%Y-%%m-%%d') AS date
        FROM progress_reports
        WHERE student_id = %s
        ORDER BY date DESC
    """, (student_id,))
    reports = cursor.fetchall()

    for report in reports:
        cursor.execute("""
            SELECT subject, grade
            FROM progress_report_subjects
            WHERE report_id = %s
        """, (report['id'],))
        report['subjects'] = cursor.fetchall()

    cursor.close()
    conn.close()
    return jsonify(reports)

#Make the Progress Reports
@app.route("/progress_reports", methods=["POST"])
def create_progress_report():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Missing JSON body"}), 400

    required = ["student_id", "term", "date", "subjects"]
    for k in required:
        if k not in data:
            return jsonify({"error": f"Missing field: {k}"}), 400

    student_id = data["student_id"]
    term = data["term"]
    remarks = data.get("remarks", "")
    date = data["date"]  # expect YYYY-MM-DD
    subjects = data["subjects"]

    if not isinstance(subjects, list) or len(subjects) == 0:
        return jsonify({"error": "subjects must be a non-empty list"}), 400

    conn = get_connection()
    cursor = conn.cursor()

    try:
        # Insert the report row
        insert_report_sql = """
            INSERT INTO progress_reports (student_id, term, remarks, date)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(insert_report_sql, (student_id, term, remarks, date))
        report_id = cursor.lastrowid

        # Insert subjects rows
        insert_subj_sql = """
            INSERT INTO progress_report_subjects (report_id, subject, grade)
            VALUES (%s, %s, %s)
        """
        subject_tuples = []
        for s in subjects:
            subj_name = s.get("subject")
            grade = s.get("grade", "")
            if not subj_name:
                conn.rollback()
                return jsonify({"error": "Each subject must have 'subject' field"}), 400
            subject_tuples.append((report_id, subj_name, grade))

        cursor.executemany(insert_subj_sql, subject_tuples)

        conn.commit()
        return jsonify({"success": True, "report_id": report_id}), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route("/student", methods=["GET"])
def get_students():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT id_student AS id, student_name AS name, class FROM student ORDER BY student_name")
    student = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(student)

#---Announcements---#

# Teacher creates announcement
@app.route('/announcements', methods=['POST'])
def create_announcement():
    data = request.get_json()
    title = data.get("title")
    message = data.get("message")
    class_name = data.get("class_name")
    teacher_id = data.get("teacher_id")

    if not all([title, message, class_name, teacher_id]):
        return jsonify({"error": "Missing fields"}), 400

    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO announcements (title, message, class_name, teacher_id)
            VALUES (%s, %s, %s, %s)
        """, (title, message, class_name, teacher_id))
        conn.commit()
        ann_id = cursor.lastrowid
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

    return jsonify({"status": "created", "id": ann_id}), 201


# Student fetches announcements (with NEW flag)
@app.route('/announcements/student/<int:student_id>', methods=['GET'])
def get_announcements_for_student(student_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    # Get student's class
    cursor.execute("SELECT class FROM student WHERE id_student=%s", (student_id,))
    row = cursor.fetchone()
    if not row:
        cursor.close()
        conn.close()
        return jsonify({"error": "Student not found"}), 404
    class_name = row['class']

    cursor.execute("""
        SELECT a.id, a.title, a.message, a.class_name, a.created_at,
               t.teacher_name,
               CASE WHEN v.id IS NULL THEN 1 ELSE 0 END AS is_new
        FROM announcements a
        LEFT JOIN teachers t ON a.teacher_id = t.teacher_id
        LEFT JOIN announcement_views v ON a.id = v.announcement_id AND v.student_id=%s
        WHERE a.class_name=%s OR a.class_name='All'
        ORDER BY a.created_at DESC
    """, (student_id, class_name))

    announcements = cursor.fetchall()

    # Convert datetime to ISO 8601
    for a in announcements:
        if isinstance(a["created_at"], datetime.datetime):
            a["created_at"] = a["created_at"].isoformat()

    cursor.close()
    conn.close()
    return jsonify(announcements)


# Mark announcement as viewed
@app.route('/announcements/<int:announcement_id>/view', methods=['POST'])
def mark_announcement_viewed(announcement_id):
    data = request.get_json()
    student_id = data.get("student_id")
    if not student_id:
        return jsonify({"error": "Missing student_id"}), 400

    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT IGNORE INTO announcement_views (announcement_id, student_id)
            VALUES (%s, %s)
        """, (announcement_id, student_id))
        conn.commit()
    except Exception as e:
        conn.rollback()
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500

    cursor.close()
    conn.close()
    return jsonify({"status": "success"})

# ✅ Get all teachers
@app.route('/teachers', methods=['GET'])
def get_teachers():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT teacher_id, teacher_name
        FROM teachers
        ORDER BY teacher_name ASC
    """)
    teachers = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(teachers)


#Get Classes
@app.route('/class', methods=['GET'])
def get_class():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT DISTINCT class FROM student ORDER BY class ASC")
    classes = [row[0] for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return jsonify(classes)

#--Quizes--


def init_db():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS quizzes (
            id INT AUTO_INCREMENT PRIMARY KEY,
            title VARCHAR(255) NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS quiz_questions (
            id INT AUTO_INCREMENT PRIMARY KEY,
            quiz_id INT NOT NULL,
            question TEXT NOT NULL,
            option_a VARCHAR(255) NOT NULL,
            option_b VARCHAR(255) NOT NULL,
            option_c VARCHAR(255) NOT NULL,
            option_d VARCHAR(255) NOT NULL,
            correct_option ENUM('A','B','C','D') NOT NULL,
            FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS quiz_results (
            id INT AUTO_INCREMENT PRIMARY KEY,
            quiz_id INT NOT NULL,
            student_name VARCHAR(100),
            score INT NOT NULL,
            total_questions INT NOT NULL,
            completed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
        )
    """)
    conn.commit()
    cursor.close()
    conn.close()

init_db()

@app.route('/api/quizzes', methods=['GET'])
def get_quizzes():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM quizzes ORDER BY created_at DESC")
    quizzes = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(quizzes)

@app.route('/api/quizzes', methods=['POST'])
def create_quiz():
    data = request.get_json()
    if "title" not in data:
        return jsonify({"error": "Missing quiz title"}), 400
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO quizzes (title) VALUES (%s)", (data["title"],))
    conn.commit()
    new_id = cursor.lastrowid
    cursor.close()
    conn.close()
    return jsonify({"id": new_id, "title": data["title"]}), 201

@app.route('/api/quizzes/<int:quiz_id>/questions', methods=['GET'])
def get_quiz_questions(quiz_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM quiz_questions WHERE quiz_id=%s", (quiz_id,))
    qs = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(qs)

@app.route('/api/quizzes/<int:quiz_id>/questions', methods=['POST'])
def add_quiz_question(quiz_id):
    data = request.get_json()
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO quiz_questions (quiz_id, question, option_a, option_b, option_c, option_d, correct_option)
        VALUES (%s,%s,%s,%s,%s,%s,%s)
    """, (quiz_id, data['question'], data['option_a'], data['option_b'],
          data['option_c'], data['option_d'], data['correct_option']))
    conn.commit()
    qid = cursor.lastrowid
    cursor.close()
    conn.close()
    return jsonify({"id": qid}), 201

@app.route('/api/quizzes/<int:quiz_id>/questions/<int:qid>', methods=['PUT'])
def update_quiz_question(quiz_id, qid):
    data = request.get_json()
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        UPDATE quiz_questions
        SET question=%s, option_a=%s, option_b=%s, option_c=%s, option_d=%s, correct_option=%s
        WHERE id=%s AND quiz_id=%s
    """, (data['question'], data['option_a'], data['option_b'],
          data['option_c'], data['option_d'], data['correct_option'], qid, quiz_id))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({"message": "Updated"})

@app.route('/api/quizzes/<int:quiz_id>/questions/<int:qid>', methods=['DELETE'])
def delete_quiz_question(quiz_id, qid):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM quiz_questions WHERE id=%s AND quiz_id=%s", (qid,quiz_id))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({"message": "Deleted"})

@app.route('/api/quizzes/<int:quiz_id>/results', methods=['POST'])
def save_result(quiz_id):
    data = request.get_json()
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO quiz_results (quiz_id, student_name, score, total_questions)
        VALUES (%s,%s,%s,%s)
    """, (quiz_id, data.get("student_name","Anonymous"), data['score'], data['total_questions']))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({"message": "Result saved"}), 201

@app.route('/api/quizzes/<int:quiz_id>/results', methods=['GET'])
def get_results(quiz_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM quiz_results WHERE quiz_id=%s", (quiz_id,))
    results = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(results)



# ---------- ASSIGNMENTS ----------
@app.get("/classes")
def list_classes():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT DISTINCT `class` FROM student ORDER BY `class` ASC")
    rows = [r[0] for r in cur.fetchall()]
    cur.close()
    conn.close()
    return jsonify(rows), 200

# ---- Student name -> class lookup (uses your existing student table) ----
@app.get("/get_class")
def get_class_by_name():
    name = request.args.get("name")
    if not name:
        return {"error": "name is required"}, 400

    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    # you can make it case-insensitive if you want: WHERE LOWER(student_name)=LOWER(%s)
    cur.execute("SELECT `class` FROM student WHERE student_name = %s LIMIT 1", (name,))
    row = cur.fetchone()
    cur.close()
    conn.close()

    if not row:
        return {"error": "Student not found"}, 404
    return {"class": row["class"]}, 200

# ---- Get current link for a class ----
@app.get("/link")
def get_link_for_class():
    class_name = request.args.get("class")
    if not class_name:
        return {"error": "class is required"}, 400

    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT id, class, url, updated_at FROM class_links WHERE class = %s", (class_name,))
    row = cur.fetchone()
    cur.close()
    conn.close()

    if not row:
        # return empty if no link set yet
        return {"class": class_name, "url": "", "updated_at": None}, 200
    return row, 200

# ---- Upsert link for a class (Teacher action) ----
@app.post("/link")
def upsert_link_for_class():
    data = request.get_json(silent=True) or {}
    class_name = (data.get("class") or "").strip()
    url = (data.get("url") or "").strip()

    if not class_name or not url:
        return {"error": "class and url are required"}, 400

    conn = get_connection()
    cur = conn.cursor()
    # upsert via insert ... on duplicate key update
    cur.execute("""
        INSERT INTO class_links (class, url)
        VALUES (%s, %s)
        ON DUPLICATE KEY UPDATE url = VALUES(url), updated_at = CURRENT_TIMESTAMP
    """, (class_name, url))
    conn.commit()
    cur.close()
    conn.close()

    return {"message": "Link saved", "class": class_name, "url": url}, 201



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
