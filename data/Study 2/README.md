# Data README file

**Dataset title:** Clean data from Study 2 for project on "The Trustability 
of AI"

**Principal investigator:** Dr. Ethan Landes (ethan.landes@gmail.com)

**Head researcher:** Dr. Jim Everett (j.a.c.everett@kent.ac.uk)

**Institution:** University of Kent

**File format:** CSV file

**File dimensions:** 17940 rows x 7 columns

**Data collected on:** 25 Nov 2024

**Columns in the dataset:**

- `PID` - numeric, participant identification number
- `Trust_Type` - character, type of trust measured, either "1_Place_Trust" ("I trust [Item]"), "2_Place_Trust" ("I trust [Item] to do that"), or "Trustworthiness" ("[Item] is trustworthy").
- `Item` - character, 30 items inserted into the measure questions.
- `Measure` - character, measure in which data was collected, either "Felicity" 
or "Sense". Structure of Felicity questions are: "I trust [item]". Structure of 
Sense questions are: "If someone said "I trust [item]", would that sentence make
sense?"
- `Rating` - numeric, 1-7 Likert scale. For Felicity questions, the scale was 
anchored 1 = Sounds weird, 7 = Sounds natural. For Sense questions, the scale 
was anchored 1 = Definitely doesn't make sense, 7 = definitely makes sense. 
- `Category` - character, category in which the item belongs. Categories are: 
"Abstract", "Inanimate_Nature", "Food", "Animate_Artifacts", "Animals", "AI", 
"Groups", "Humans", "Inanimate_Artifacts". Notice the addition and slight relabeling from Study 1 to better reflect current thinking about framing.          
