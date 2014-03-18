#why.
You are working on a project that has RTL and LTR versions (Arabic/English Layout), In the past the translation from LTR to RTL was hard, you had to have two different copies of the xib (or story board) and recreate the whole layout

##AutoLayout to the rescue.
This was all fixed with AutoLayout, when you use Leading to Tailing constraints, the mirroring of LTR and RTL happens automatically.

If the user changes the language from the Settings app, the layout will mirror.

##YAY problem solved ... But!!!
But no, some clients want to be able to change the language from within the app, which is wrong for the following:

- Your settings language is english and some application still are arabic
- It sucks cause you will have to do the mirroring by hand.

##Do I sense a solution.
Yes sure, My handsome reader.   

I here present you layout_translator (which is a name that i dont like, but i couldnt find a better one) which will do most of the work for you.

###Installation
1. Clone the repo
2. `bundle install`

###How to use.
1. Create your storyboards normally, using Leading to Tailing
2. After you are finished with the story board call:
    
        //Translate the Leading to Tailing to LTR
        ./layout_translator.rb /path/to/the/stoaryboard -l -o /path/to/the/generated

        //Translate the Leading to Tailing to RTL
        ./layout_translator.rb /path/to/the/stoaryboard -r -o /path/to/the/generated
3. Add the generated files to your project

#Usages
For usage call without any args `./layout_translator.rb`
