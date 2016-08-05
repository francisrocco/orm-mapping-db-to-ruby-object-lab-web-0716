class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students;
    SQL

    all_rows = DB[:conn].execute(sql)
    all_rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?;
    SQL

    newbie = DB[:conn].execute(sql, name)
    self.new_from_db(newbie.first)

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(name) FROM students
      GROUP BY grade
      HAVING grade = 9
    SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT COUNT(name) FROM students
      GROUP BY grade
      HAVING grade < 12
    SQL

    DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?;
    SQL

    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT 1;
    SQL

    first_stud = DB[:conn].execute(sql)
    self.new_from_db(first_stud[0])
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?;
    SQL

    DB[:conn].execute(sql, grade)
  end

end
