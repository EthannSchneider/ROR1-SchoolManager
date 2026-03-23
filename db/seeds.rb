# This file should ensure the existence of records required to run the application
# in every environment. The data below is intentionally idempotent so it can be
# safely re-run with `bin/rails db:seed`.

SEED_PASSWORD = "Password123!"

def upsert_room!(name)
  room = Room.find_or_initialize_by(name: name)
  room.update!(name: name)
  room
end

def upsert_collaborator!(type:, email:, avs_number:, **attributes)
  collaborator = type.constantize.find_or_initialize_by(email: email)
  collaborator.assign_attributes(attributes.merge(avs_number: avs_number))
  collaborator.password = SEED_PASSWORD if collaborator.new_record?
  collaborator.password_confirmation = SEED_PASSWORD if collaborator.new_record?
  collaborator.save!
  collaborator
end

def upsert_student!(email:, avs_number:, school_class:, **attributes)
  student = Student.find_or_initialize_by(email: email)
  student.assign_attributes(attributes.merge(avs_number: avs_number, school_class: school_class))
  student.password = SEED_PASSWORD if student.new_record?
  student.password_confirmation = SEED_PASSWORD if student.new_record?
  student.save!
  student
end

def upsert_schedule!(unity:, room:, day:, start_time:, end_time:, school_classes:, collaborators:)
  schedule = Schedule.find_or_initialize_by(unity: unity, room: room, day: day, start_time: start_time)
  schedule.end_time = end_time
  schedule.school_classes = school_classes
  schedule.collaborators = collaborators
  schedule.save!
  schedule
end

ActiveRecord::Base.transaction do
  plans_with_modules = {
    "Informaticien CFC" => {
      "Developpement d'applications" => [
        "Modelisation des donnees",
        "Ruby on Rails",
        "Tests et qualite logicielle"
      ],
      "Infrastructure" => [
        "Administration systeme",
        "Reseaux",
        "Securite de base"
      ]
    },
    "Mediamaticien CFC" => {
      "Communication numerique" => [
        "Gestion de contenu",
        "UX et accessibilite",
        "Production multimedia"
      ],
      "Gestion de projet" => [
        "Methodes agiles",
        "Travail interdisciplinaire"
      ]
    }
  }

  plans = plans_with_modules.map do |plan_name, modules|
    plan = FormationPlan.find_or_initialize_by(name: plan_name)
    plan.save!

    formation_modules = modules.map do |module_name, unity_names|
      formation_module = FormationModule.find_or_initialize_by(name: module_name)
      formation_module.save!

      unity_names.each do |unity_name|
        unity = formation_module.unities.find_or_initialize_by(name: unity_name)
        unity.save!
      end

      formation_module
    end

    plan.formation_modules = formation_modules
    plan.save!
    [plan_name, plan]
  end.to_h

  rooms = [
    "A101",
    "A202",
    "B105",
    "Lab Reseau"
  ].index_with { |name| upsert_room!(name) }

  collaborators = {
    dean: upsert_collaborator!(
      type: "Dean",
      email: "direction@schoolmanager.test",
      avs_number: "756.0000.0000.01",
      firstname: "Claire",
      lastname: "Monnet",
      phone_number: "+41 21 555 10 10",
      street: "Rue du Lac",
      street_number: "10",
      postal_code: "1400",
      city: "Yverdon-les-Bains",
      birthdate: Date.new(1982, 4, 12),
      contract_start: Date.new(2021, 8, 1),
      contract_end: nil
    ),
    teacher_dev: upsert_collaborator!(
      type: "Teacher",
      email: "nina.borel@schoolmanager.test",
      avs_number: "756.0000.0000.02",
      firstname: "Nina",
      lastname: "Borel",
      phone_number: "+41 21 555 10 11",
      street: "Rue des Alpes",
      street_number: "18",
      postal_code: "1004",
      city: "Lausanne",
      birthdate: Date.new(1990, 9, 3),
      contract_start: Date.new(2023, 8, 1),
      contract_end: nil
    ),
    teacher_sys: upsert_collaborator!(
      type: "Teacher",
      email: "marc.reymond@schoolmanager.test",
      avs_number: "756.0000.0000.03",
      firstname: "Marc",
      lastname: "Reymond",
      phone_number: "+41 21 555 10 12",
      street: "Chemin du Stand",
      street_number: "5",
      postal_code: "1020",
      city: "Renens",
      birthdate: Date.new(1987, 1, 25),
      contract_start: Date.new(2022, 2, 1),
      contract_end: nil
    ),
    coordinator: upsert_collaborator!(
      type: "Collaborator",
      email: "lea.favre@schoolmanager.test",
      avs_number: "756.0000.0000.04",
      firstname: "Lea",
      lastname: "Favre",
      phone_number: "+41 21 555 10 13",
      street: "Rue Centrale",
      street_number: "27",
      postal_code: "1110",
      city: "Morges",
      birthdate: Date.new(1994, 6, 8),
      contract_start: Date.new(2024, 1, 1),
      contract_end: nil
    )
  }

  school_classes = {
    "INF-1A" => SchoolClass.find_or_initialize_by(name: "INF-1A"),
    "INF-2B" => SchoolClass.find_or_initialize_by(name: "INF-2B"),
    "MED-1A" => SchoolClass.find_or_initialize_by(name: "MED-1A")
  }

  school_classes["INF-1A"].update!(responsable: collaborators[:teacher_dev], formation_plan: plans.fetch("Informaticien CFC"))
  school_classes["INF-2B"].update!(responsable: collaborators[:teacher_sys], formation_plan: plans.fetch("Informaticien CFC"))
  school_classes["MED-1A"].update!(responsable: collaborators[:coordinator], formation_plan: plans.fetch("Mediamaticien CFC"))

  students = [
    {
      email: "lucas.meyer@schoolmanager.test",
      avs_number: "756.1000.0000.01",
      firstname: "Lucas",
      lastname: "Meyer",
      school_class: school_classes["INF-1A"],
      birthdate: Date.new(2007, 2, 14),
      admission_date: Date.new(2025, 8, 18),
      end_date: Date.new(2029, 6, 30)
    },
    {
      email: "emma.rochat@schoolmanager.test",
      avs_number: "756.1000.0000.02",
      firstname: "Emma",
      lastname: "Rochat",
      school_class: school_classes["INF-1A"],
      birthdate: Date.new(2008, 5, 9),
      admission_date: Date.new(2025, 8, 18),
      end_date: Date.new(2029, 6, 30)
    },
    {
      email: "noah.girard@schoolmanager.test",
      avs_number: "756.1000.0000.03",
      firstname: "Noah",
      lastname: "Girard",
      school_class: school_classes["INF-2B"],
      birthdate: Date.new(2006, 11, 21),
      admission_date: Date.new(2024, 8, 19),
      end_date: Date.new(2028, 6, 30)
    },
    {
      email: "zoe.moret@schoolmanager.test",
      avs_number: "756.1000.0000.04",
      firstname: "Zoe",
      lastname: "Moret",
      school_class: school_classes["MED-1A"],
      birthdate: Date.new(2007, 7, 30),
      admission_date: Date.new(2025, 8, 18),
      end_date: Date.new(2029, 6, 30)
    }
  ].map do |student_attributes|
    school_class = student_attributes.delete(:school_class)
    upsert_student!(**student_attributes, school_class: school_class)
  end

  unity_by_name = Unity.includes(:formation_module).index_by(&:name)

  grade_templates = {
    "Lucas Meyer" => {
      "Modelisation des donnees" => 5.5,
      "Ruby on Rails" => 5.0,
      "Tests et qualite logicielle" => 4.5
    },
    "Emma Rochat" => {
      "Modelisation des donnees" => 4.5,
      "Ruby on Rails" => 5.5,
      "Tests et qualite logicielle" => 5.0
    },
    "Noah Girard" => {
      "Administration systeme" => 5.0,
      "Reseaux" => 4.5,
      "Securite de base" => 5.5
    },
    "Zoe Moret" => {
      "Gestion de contenu" => 5.0,
      "UX et accessibilite" => 5.5,
      "Production multimedia" => 4.5
    }
  }

  students.index_by(&:full_name).each do |student_name, student|
    grade_templates.fetch(student_name).each_with_index do |(unity_name, value), index|
      Grade.find_or_initialize_by(student: student, unity: unity_by_name.fetch(unity_name), test_date: Date.new(2026, 2, 2) + index.weeks).tap do |grade|
        grade.value = value
        grade.save!
      end
    end
  end

  schedule_templates = [
    {
      unity_name: "Ruby on Rails",
      room_name: "A101",
      weekday: 1,
      start_time: "08:15",
      end_time: "11:30",
      school_classes: [ school_classes["INF-1A"] ],
      collaborators: [ collaborators[:teacher_dev] ]
    },
    {
      unity_name: "Modelisation des donnees",
      room_name: "A202",
      weekday: 3,
      start_time: "08:15",
      end_time: "11:30",
      school_classes: [ school_classes["INF-1A"] ],
      collaborators: [ collaborators[:teacher_dev] ]
    },
    {
      unity_name: "Tests et qualite logicielle",
      room_name: "A101",
      weekday: 4,
      start_time: "13:15",
      end_time: "16:30",
      school_classes: [ school_classes["INF-1A"] ],
      collaborators: [ collaborators[:teacher_dev], collaborators[:coordinator] ]
    },
    {
      unity_name: "Administration systeme",
      room_name: "Lab Reseau",
      weekday: 1,
      start_time: "13:15",
      end_time: "16:30",
      school_classes: [ school_classes["INF-2B"] ],
      collaborators: [ collaborators[:teacher_sys] ]
    },
    {
      unity_name: "Reseaux",
      room_name: "Lab Reseau",
      weekday: 2,
      start_time: "13:15",
      end_time: "16:30",
      school_classes: [ school_classes["INF-2B"] ],
      collaborators: [ collaborators[:teacher_sys], collaborators[:coordinator] ]
    },
    {
      unity_name: "Securite de base",
      room_name: "B105",
      weekday: 4,
      start_time: "08:15",
      end_time: "11:30",
      school_classes: [ school_classes["INF-2B"] ],
      collaborators: [ collaborators[:teacher_sys] ]
    },
    {
      unity_name: "Gestion de contenu",
      room_name: "B105",
      weekday: 1,
      start_time: "10:15",
      end_time: "12:00",
      school_classes: [ school_classes["MED-1A"] ],
      collaborators: [ collaborators[:coordinator] ]
    },
    {
      unity_name: "UX et accessibilite",
      room_name: "B105",
      weekday: 2,
      start_time: "10:15",
      end_time: "12:00",
      school_classes: [ school_classes["MED-1A"] ],
      collaborators: [ collaborators[:coordinator] ]
    },
    {
      unity_name: "Production multimedia",
      room_name: "A202",
      weekday: 4,
      start_time: "10:15",
      end_time: "12:00",
      school_classes: [ school_classes["MED-1A"] ],
      collaborators: [ collaborators[:coordinator] ]
    },
    {
      unity_name: "Methodes agiles",
      room_name: "A101",
      weekday: 5,
      start_time: "08:15",
      end_time: "10:00",
      school_classes: [ school_classes["MED-1A"] ],
      collaborators: [ collaborators[:teacher_dev], collaborators[:coordinator] ]
    },
    {
      unity_name: "Travail interdisciplinaire",
      room_name: "A202",
      weekday: 5,
      start_time: "10:15",
      end_time: "12:00",
      school_classes: [ school_classes["MED-1A"], school_classes["INF-1A"] ],
      collaborators: [ collaborators[:teacher_dev], collaborators[:coordinator] ]
    }
  ]

  schedule_definitions = []
  first_monday = Date.new(2026, 3, 23)

  6.times do |week_offset|
    week_start = first_monday + week_offset.weeks

    schedule_templates.each do |template|
      schedule_definitions << template.merge(day: week_start + template[:weekday].days)
    end
  end

  schedule_definitions.concat([
    {
      unity_name: "Ruby on Rails",
      room_name: "A101",
      day: Date.new(2026, 4, 15),
      start_time: "13:15",
      end_time: "16:30",
      school_classes: [ school_classes["INF-1A"] ],
      collaborators: [ collaborators[:teacher_dev] ]
    },
    {
      unity_name: "Securite de base",
      room_name: "Lab Reseau",
      day: Date.new(2026, 4, 22),
      start_time: "10:15",
      end_time: "12:00",
      school_classes: [ school_classes["INF-2B"] ],
      collaborators: [ collaborators[:teacher_sys], collaborators[:coordinator] ]
    },
    {
      unity_name: "Production multimedia",
      room_name: "B105",
      day: Date.new(2026, 4, 29),
      start_time: "13:15",
      end_time: "16:30",
      school_classes: [ school_classes["MED-1A"] ],
      collaborators: [ collaborators[:coordinator] ]
    },
    {
      unity_name: "Travail interdisciplinaire",
      room_name: "A202",
      day: Date.new(2026, 5, 1),
      start_time: "13:15",
      end_time: "16:30",
      school_classes: [ school_classes["INF-1A"], school_classes["MED-1A"] ],
      collaborators: [ collaborators[:teacher_dev], collaborators[:teacher_sys], collaborators[:coordinator] ]
    }
  ])

  schedule_definitions.each do |definition|
    upsert_schedule!(
      unity: unity_by_name.fetch(definition[:unity_name]),
      room: rooms.fetch(definition[:room_name]),
      day: definition[:day],
      start_time: definition[:start_time],
      end_time: definition[:end_time],
      school_classes: definition[:school_classes],
      collaborators: definition[:collaborators]
    )
  end
end

puts "Seeds loaded successfully."
puts "Password for generated accounts: #{SEED_PASSWORD}"
puts "People: #{Person.count} | Classes: #{SchoolClass.count} | Schedules: #{Schedule.count} | Grades: #{Grade.count}"
