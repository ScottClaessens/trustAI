# Data README file

**Dataset title:** Clean data from Study 1 for project on "The Trustability 
of AI"

**Principal investigator:** Dr. Ethan Landes (ethan.landes@gmail.com)

**Head researcher:** Dr. Jim Everett (j.a.c.everett@kent.ac.uk)

**Institution:** University of Kent

**File format:** CSV file

**File dimensions:** 5238 rows x 5 columns

**Data collected on:** 10 October 2024

**Columns in the dataset:**

- `PID` - numeric, participant identification number
- `Measure` - character, measure in which data was collected, either "Felicity" 
or "Sense". Structure of Felicity questions are: "I trust [item]". Structure of 
Sense questions are: "If someone said "I trust [item]", would that sentence make
sense?"
- `Item` - character, 27 items inserted into the measure questions.
- `Rating` - numeric, 1-7 Likert scale. For Felicity questions, the scale was 
anchored 1 = Sounds weird, 7 = Sounds natural. For Sense questions, the scale 
was anchored 1 = Definitely doesn't make sense, 7 = definitely makes sense. 
- `Category` - character, category in which the item belongs. Categories are: 
"Abstract", "Inanimate_Nature", "Food", "Animate_Artifacts", "Animals", "AI", 
"Group_Agents", "Agents"         
