Job Hunter
====

Application developed to scrape and apply for jobs from the following sources:
- www.indeed.com
- https://angel.co/jobs
- more coming soon

The list of jobs will be limited to the "easy to apply" ones from the page. The application is personalized by giving the user the capabilities of entering his/her information to store and later use this data. The user is capable of uploading his/her resume and updating a new version of it. The search parameters, which include the job title, location and pages to inspect, are determined by the user input. 

The application has a matching algorithm that lets the user apply to jobs in which he/she is more than 50% compatible against the requirements for that specific position. The user can inspect the jobs and decide if it is appropiate to apply. 

## Ubuntu 16.04 minimal install.
```shell
apt update
apt install ruby ruby-bundler build-essential zlib1g-dev sqlite3 libpq-dev libsqlite3-dev git qt4-qmake qt4-default libqtwebkit-dev libqtwebkit4 nodejs git
git clone https://github.com/jmopr/job-hunter.git
cd job-hunter/
bundle install
gem install sqlite3
./bin/setup
rails s
```
This starts the application on: http://localhost:3000


If you have any questions, contact the maintainers of this project:

- Juan Ortiz (jmopr83@gmail.com)
- Rodney Perez (rodneyeperez@gmail.com)
- Perhaps you? Please e-mail us if you'd like to get involved!
