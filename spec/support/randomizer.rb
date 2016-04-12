def rand_email
  "#{rand_text}@example.com"
end

def rand_text(size = 5)
  ('a'..'z').to_a.sample(size).join
end
