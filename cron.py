from crontab import CronTab

cron = CronTab()
# TODO: so wrong how do i get the path to python?? can't use /usr/bin
job = cron.new(command='/nix/store/7ffbx8jwwfjhiqw6skvqfdwy8qhv0x2q-python-2.7.10/bin/python main.py')
job.minute.every(2)