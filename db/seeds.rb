users = User.create([
                      {
                        login: 'admin',
                        email: 'admin@example.com',
                        password: 'secret',
                        role: 'admin'
                      },
                      {
                        login: 'user',
                        email: 'user@example.com',
                        password: 'qwerty'
                      },
                      {
                        login: 'john',
                        email: 'john@example.com',
                        password: 'zaq12wsx'
                      }
                    ])

categories = Category.create([
                                { name: 'Lorem ipsum', user: users.first },
                                { name: 'IT', user: users.first },
                                { name: 'Art', user: users.last }
                            ])

Post.create([
              {
                title: 'Lorem ipsum',
                body: 'Lorem ipsum dolor sit amet, consectetur.',
                user: users.last,
                category: categories.first
              },
              {
                title: 'Ruby on Rails',
                body: 'Lorem ipsum dolor sit amet, consectetur.',
                user: users.last,
                category: categories.last
              }
            ])

Session.create([
                  { token: SecureRandom.hex, user: users.first },
                  { token: SecureRandom.hex, user: users.last }
              ])
