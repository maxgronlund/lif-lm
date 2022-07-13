# Start Postgres
```
$ pg_ctl -D /usr/local/var/postgres start
```
# Run.Umbrella

## NOTICE
for the css file to be updated NOT NEEDED
when updating apps/run_web/assets/css/app.css, you have to run 
 ``` 
 $ mix tailwind default 
```
## Gettext
```
$ mix gettext.extract --merge
```

## Resources
https://www.headway.io/blog/client-side-drag-and-drop-with-phoenix-liveview
https://flowbite.com/docs/getting-started/quickstart/


### tailwind
- card [codepen](https://codepen.io/handplant/pen/MWWaYNw?editors=1000)

## Hekoku
[heroku](https://pure-forest-93343.herokuapp.com/)

- Aplication name: pure-forest-93343
- heroku run "POOL_SIZE=2 mix hello.task"