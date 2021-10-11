# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Worker.create(name: 'Doen', last_name: 'John', role: 'manager', email: 'john_doe@doe.com')
Worker.create(name: 'John', last_name: 'Doe', role: 'software_engineer', email: 'john_doe@doe.com')
VacationRequest.create(vacation_start_date: '2021-11-10', vacation_end_date: '2021-11-14', worker_id: 2)
VacationRequest.create(vacation_start_date: '2021-11-15', vacation_end_date: '2021-11-20', worker_id: 2)