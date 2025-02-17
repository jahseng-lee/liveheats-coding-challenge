if Student.count == 0
  [
    { first_name: "Megumi", last_name: "Fushigoro" },
    { first_name: "Yuji", last_name: "Itadori" },
    { first_name: "Nobara", last_name: "Kugasaki"},
    { first_name: "Aoi", last_name: "Todo" }
  ].each do |student|
    Student.create!(
      first_name: student[:first_name],
      last_name: student[:last_name]
    )
  end
else
  puts "Students already seeded"
end
