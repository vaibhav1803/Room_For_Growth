extends Node

# The database of thoughts organized by Reality Stage
# Keys starting with "Scene_" are Loop 1 (Nostalgia)
# Keys starting with "L2_" are Loop 2 (Trauma/Glitch)
# Keys starting with "L3_" are Chapter 3 / Loop 3 (The Truth / Balanced Lens)

var loops = {
	# --- LOOP 1: NOSTALGIA ---
	"Scene_1_Office": {
		"entry": [
			"The cursor blinks. On. Off. On. Off. It’s mocking me.",
			"If I type 'Yes' one more time, I think my fingers will snap."
		],
		"trigger_glitch": [
			"What is this? [RELIVE YOUR BEST MOMENTS?]",
			"A glitch? A virus? ... Or a door?"
		]
	},
	"Scene_2_College": {
		"entry": [
			"The air... it tastes like cheap coffee and freedom.",
			"Wait... I’m in the quad? I was just... This is incredible."
		],
		"viva_fail": [
			"I can't remember the words. They're slipping away.",
			"Why is my chest tightening? I want to go back further."
		]
	},
	"Scene_3_School": {
		"entry": [
			"Smaller. Simpler. The smell of wood polish and chalk.",
			"No Vivas here. Just the slow afternoon sun."
		],
		"teacher_anger": [
			"Not again. The expectations... it’s just a different kind of cage.",
			"Take me back to the very start. Before the words."
		]
	},
	"Scene_4_Toddler": {
		"entry": [
			"Silence. Softness. Finally.",
			"I want to walk away. Why won't my legs work?",
			"I am trapped in this soft cage. Is this the end of the line?"
		]
	},
	"Scene_5_Park": {
		"entry": [
			"It hurts to breathe.",
			"I spent my whole life looking backward... and now there's nothing left in front of me."
		]
	},
	"System_Reset": {
		"crash": [
			"> CRITICAL ERROR: Reality Simulation Failed.",
			"> Inconsistency detected in 'Subject_Nostalgia_Path'.",
			"> LOGIC LOOP DETECTED: Subject rejected reality -> Subject rejected memory -> Subject rejected biology.",
			"> RESETTING..."
		]
	},

	# --- LOOP 2: TRAUMA / GLITCH ---
	"L2_Scene_1_Office": {
		"entry": [
			"System Recovery... 10%... 20%...",
			"The cabin feels smaller today. The screen flickering is hurting my eyes.",
			"I need to download these files before He gets here."
		],
		"senior_scolding": [
			"Wait... I remember this voice.",
			"This isn't a break. This is the day I almost got fired.",
			"Close your eyes. Escape. Please."
		]
	},
	"L2_Scene_2_College": {
		"entry": [
			"The hallway is wide, but the shadows are too long.",
			"The lights are buzzing like angry wasps.",
			"Friend: 'Last one to the Professor buys lunch! Go!'"
		],
		"glitch_fall": [
			"I won... I got the highest marks...",
			"CRACK.",
			"Why do the good parts always end with a fall?"
		]
	},
	"L2_Scene_3_School": {
		"entry": [
			"Dust. It smells like old dust.",
			"I'm on my knees. Why am I on my knees?",
			"Ah. The math test. I hated this day."
		],
		"fan_crash": [
			"CRASH.",
			"I was such a moron. I thought this was funny back then...",
			"Now I just feel like an idiot. Take me back to when I couldn't cause damage."
		]
	},
	"L2_Scene_4_Toddler": {
		"entry": [
			"The rug is a landscape. The chair leg is a tower.",
			"I can move. I’m small, but I’m free.",
			"Just me and my bear. No fans to break. No bosses to fear."
		],
		"white_light": [
			"A shadow? It's massive.",
			"Warm hands... lifting me up?",
			"Is this... peace?"
		]
	},

	# --- LOOP 3 / CHAPTER 3: THE TRUTH (BALANCED LENS) ---
	# Visual Filter note (for you): Natural lighting, clear colors (no more sepia or glitch).
	# The "System Pop-up" is the only artificial element left.

	# Stage 4: The Toddler Room (The Choice)
	"L3_Scene_4_Toddler": {
		"entry": [
			"The room is warm. Not soft like a dream... warm like a real morning.",
			"I reach for the teddy. It's worn. It's perfect.",
			"The world goes quiet. The hand lifts me up... and the screen freezes."
		],

		# Use this as the text that appears before your popup choice UI
		"system_popup_error": [
			"ERROR: MEMORY FRAGMENTED. DATA MANIPULATION ACCESSIBLE."
		],

		# Popup choice labels (optional, if your popup UI needs text)
		"choice_prompt": [
			"CHOOSE:",
			"A) REWRITE VERSES (Live a fake life)",
			"B) ACCEPTANCE (Let it be)"
		],

		# Choice A -> Bad Ending
		"rewrite_verses_bad": [
			"I can stitch the cracks into something prettier.",
			"I can rewrite the pain until it sounds like poetry.",
			"But it isn't mine anymore. It's a life that only looks like living."
		],

		# Choice B -> Good Ending (+ Mother dialogue)
		"acceptance_good": [
			"I don't need to fix it. I don't need to polish it.",
			"I just need to hold it. And let it be what it was.",
			"Look at you... my brave little soul. You have a whole world of flashy things in front of you, but you chose the one thing that felt like home. You didn't care if it was old or simple. You just knew it was yours. Never lose that, okay? Love yourself as you are, before the world tries to tell you who to be."
		]
	},

	# Stage 3: The School (The Relief) - Minigame: Breakout (exam papers)
	"L3_Scene_3_School": {
		"entry": [
			"I blink on her shoulder and wake up at a school desk.",
			"The sunlight is clean. The air is clear.",
			"The papers look heavy... but they aren't me."
		],

		# After Breakout ends (regardless of score)
		"after_minigame": [
			"I wasn't the best at math. I broke the fan once.",
			"I was average... and for the first time, 'average' feels like enough.",
			"I'm not a number; I'm a person. And I'm ready to leave."
		]
	},

	# Stage 2: The College (The Goodbye) - Minigame: Pong / Table Tennis
	"L3_Scene_2_College": {
		"entry": [
			"Bright sun. Convocation day.",
			"Caps in the air like birds finally set free.",
			"My best friend's silhouette grins. 'One last game?'"
		],

		# After Pong ends (win/lose doesn’t matter)
		"after_minigame": [
			"I was lonely here sometimes. I was stressed.",
			"But these people... they were my world for a while.",
			"Thank you for being part of my mess."
		]
	},

	# Stage 1: The Office (The Present) - Minigame: Whack-a-Boss (non-stressful)
	"L3_Scene_1_Office": {
		"entry": [
			"I'm back in my cabin.",
			"The boss walks by and drops a stack of papers like it's nothing.",
			"And maybe... it is nothing."
		],

		# After Whack-a-Boss ends
		"after_minigame": [
			"It’s just a job.",
			"It’s not my identity.",
			"It’s just the room I’m in right now."
		],

		# Final interaction: incoming wife video call, toddler with same teddy
		"final_call": [
			"A phone vibrates on the desk.",
			"[INCOMING VIDEO CALL: WIFE]",
			"A small window opens.",
			"She's hugging the exact same brown teddy bear.",
			"She has your eyes... and your heart.",
			"She doesn't care about the flashy toys either."
		]
	},

	# Final system message (end card)
	"L3_System_End": {
		"the_end": [
			"HOPE YOU ARE SATISFIED WITH OUR EXPERIENCE.",
			"LIFE IS NOT A GLITCH TO BE FIXED, BUT A STORY TO BE ACCEPTED.",
			"THE END."
		]
	}
}
