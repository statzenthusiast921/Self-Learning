#!/usr/bin/env python
# coding: utf-8

# In[1]:


#Movie Collection App

#USER STORY:

#As a user I would like to be able to:
# 1.) Add new movies to my collection
#    so I can keep track of all my movies
# 2.) List all the movies in my collection
#    so I can see what movies I already have
# 3.) Find a movie by using the movie title
#.   so I can locate a specific movie easily when the collection grows



# In[2]:


#Implementation Tasks
#1.) Decide where to store movies in code
#2.) Decide what data we want to store for each movie
#3.) Show the user a menu and let them pick an option
#4.) Implement each requirement in turn, each as a separate function
#5.) Stop running the program when they type 'q' in the menu


# In[3]:


#1.) Where to store movies --> normally a database, but for this we will store in Python list
#eg: movies=[]


# In[4]:


#2.) What to store for each movie --> we'll create a dictionary (movie title, director, release year)
#eg: title=input("Enter movie title: ")
#eg: director=input("Enter movie director: ")
#eg: year=input("Enter movie release year: ")

#movies.append({
#'title' : title,
#'director' : director,
#'year' : year
#})


# In[5]:


#3.) Show the user a menu
# we need user input
# run a loop and get their input again at the end


# In[6]:


#4.) Implement each requirement in turn


# In[ ]:


MENU_PROMPT = "\nEnter 'a' to add a movie, 'l' to see your movies, 'f' to find a movie by title, or 'q' to quit: "
movies = []


def add_movie():
    title = input("Enter the movie title: ")
    director = input("Enter the movie director: ")
    year = input("Enter the movie release year: ")

    movies.append({
        'title': title,
        'director': director,
        'year': year
    })


def show_movies():
    for movie in movies:
        print_movie(movie)


def print_movie(movie):
    print("Title: "+ str(movie['title']))
    print("Director: "+str(movie['director']))
    print("Release year: "+str(movie['year']))


def find_movie():
    search_title = input("Enter movie title you're looking for: ")

    for movie in movies:
        if movie["title"] == search_title:
            print_movie(movie)


user_options = {
    "a": add_movie,
    "l": show_movies,
    "f": find_movie
}


def menu():
    selection = input(MENU_PROMPT)
    while selection != 'q':
        if selection in user_options:
            selected_function = user_options[selection]
            selected_function()
        else:
            print('Unknown command. Please try again.')

        selection = input(MENU_PROMPT)


menu()


# In[ ]:




