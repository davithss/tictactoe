# Tic Tac Toe Game

## Information

* I have separated apps for this game, they are:

  - /tictac -> Game engine
  - /client -> Command-line interface game play
  
* CLI play

  - ![](http://g.recordit.co/4DZwtDMVVH.gif)

* CLI play using Genserver

  - Open a terminal on Tictac directory and run the server:
  ```
    iex --sname tictac -S mix
    # to see the Supervisor and their proccess you must go on Application tab
    :observer.start 
  ```
  - Open another terminal on Client directory and run it:
  ```
    -> iex --sname client1 -S mix
    -> Client.play
   after that command check it out the Observer and you gonna se the PID of the process
  ```
   
## Work in progess
  - /client prompter tests

## Next Step
  - /web_client -> Running Phoenix
  - /socket_client -> Running Web sockets
