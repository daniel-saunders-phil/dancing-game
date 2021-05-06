turtles-own [
  strategy
;  0 = dark blue, always A
;  1 = light blue, always B
;  2 = orange, a vs male // b vs female
;  3 = burgandy, b vs male // a vs female
  payoff
;  0 = fail to coordinate // lose
;  1 = coordinate // win
  learning-style
;  0 = indiscriminate learning
;  1 = same-sex learning
;  2 = opposite-sex learning
  sex
;  0 = male
;  1 = female
]

to setup

  ; initializes the model

  clear-all
  reset-ticks

  ; produces a number of agents according to the dimensions of
  ; the grid

  ask patches [sprout 1]
  set-up-strategies

  ; the agents are visually organized so females go on the
  ; top half of the grid and males go on the bottom half

 ask turtles with [ycor >= 5] [
    set sex 1
    set shape "circle"]
  ask turtles with [ycor < 5] [
    set sex 0
    set shape "square"]

  ; agents are given colours corresponding to their strategy.
  ; the key is found above in the 'turtles-own' block
  ; and if learning styles are turned on, they are randomly
  ; assigned one of the three learning styles.

  ask turtles [
    recolor
    if learning_styles? = true [
      set learning-style random 3]]
end

to set-up-strategies

  ; assigns agents strategies based on user-controlled parameters
  ; whether there are type-conditional strategies are present
  ; and the sliders that control the starting frequencies of each strategy

  if type-players? = false [

    ; assigns some % of turtles to use light blue based on
    ; parameter initial-light-blue and set the rest to dark blue

    ask turtles [set strategy 0]
    ask n-of (count turtles * (initial-light-blue / 100)) turtles with [strategy = 0]
      [set strategy 1]]

  if type-players? = true [

    ; assign some % of turtles to each of strategies based on
    ; each of the sliders and set the rest to dark blue
    ; an error results if the user inputs impossible combinations
    ; of frequencies

    if initial-light-blue + initial-burgandy + initial-orange > 100 [
      error "initial strategy distribution exceeds 100% of the population"]

    ask turtles [set strategy 0]
    ask n-of (count turtles * (initial-light-blue / 100)) turtles with [strategy = 0]
      [set strategy 1]
    ask n-of (count turtles * (initial-orange / 100)) turtles with [strategy = 0]
      [set strategy 2]
    ask n-of (count turtles * (initial-burgandy / 100)) turtles with [strategy = 0]
      [set strategy 3]]
end
;========================================dynamic procedures======================

to go
  ; the main function - on each tick of the model, the agents play, learn and mutate
  ; if the learning style mechanism is enabled, they also update their learning style
  ; and mutate it

  ask turtles [
    play
    learn
    mutate
    if learning_styles? = true [learn-learning-style]
    if learning_styles? = true [mutate-ls]
    recolor]
  tick
end

;==========================================playing================================


to play
  ; agents pair randomly and play the dancing
  ; game using their strategies

  let p2 one-of other turtles
  let s2 [strategy] of p2
  let local-sex [sex] of p2


  ; a long series of nested conditionals determines the outcome
  ; of the interaction based on the agents' sex and strategy
  ; first it asks what the strategy of the agent is
  ; then it asks the agent's sex
  ; and then the partners player's strategy
  ; and if the agent's strategy is type-conditional,
  ; it also asks the partner's sex.
  ; based on those conditions, both agents are assigned a payoff

  ; unconditional strategies

  if strategy = 0 [ ;if dark blue

    if sex = 0 [ ;if male
      if s2 = 0 or s2 = 2 [ ;playing against dark blue or orange
        set payoff 0 ;lose
        ask p2 [set payoff 0]]

      if s2 = 1 or s2 = 3 [ ;playing against light blue or burgandy
        set payoff 1 ;win
        ask p2 [set payoff 1]]]

    if sex = 1 [ ;if female
      if s2 = 0 or s2 = 3 [ ;playing against dark blue or burgandy
        set payoff 0; lose
        ask p2 [set payoff 0]]

      if s2 = 1 or s2 = 2 [ ;playing against light blue or orange
        set payoff 1 ;win
        ask p2 [set payoff 1]]]]


  if strategy = 1 [ ;if light blue

    if sex = 0 [ ;and sex is male
      if s2 = 1 or s2 = 3 [ ;playing against a light blue or a burgandy
        set payoff 0
        ask p2 [set payoff 0]]

      if s2 = 0 or s2 = 2 [ ;playing against a dark blue or an organge
        set payoff 1
        ask p2 [set payoff 1]]]

    if sex = 1 [ ;if sex is female
      if s2 = 1 or s2 = 2 [ ;and playing against another light blue or an orange
        set payoff 0
        ask p2 [set payoff 0]]

      if s2 = 0 or s2 = 3 [ ;or playing against a dark blue or a burgandy
        set payoff 1
        ask p2 [set payoff 1]]]]

  ;conditional strategies

  if strategy = 2 [

    if sex = 0 [

      if local-sex = 0 [
        if s2 = 0 or s2 = 2 [
          set payoff 0
          ask p2 [set payoff 0]]
        if s2 = 1 or s2 = 3 [
          set payoff 1
          ask p2 [set payoff 1]]]

      if local-sex = 1 [
        if s2 = 1 or s2 = 3 [
          set payoff 0
          ask p2 [set payoff 0]]
        if s2 = 0 or s2 = 2 [
          set payoff 1
          ask p2 [set payoff 1]]]]

    if sex = 1 [

      if local-sex = 0 [
        if s2 = 0 or s2 = 3 [
          set payoff 0
          ask p2 [set payoff 0]]
        if s2 = 1 or s2 = 2 [
          set payoff 1
          ask p2 [set payoff 1]]]

      if local-sex = 1 [
        if s2 = 1 or s2 = 2 [
          set payoff 0
          ask p2 [set payoff 0]]
        if s2 = 0 or s2 = 3 [
          set payoff 1
          ask p2 [set payoff 1]]]]]

  if strategy = 3 [

    if sex = 0 [

      if local-sex = 0 [
        if s2 = 1 or s2 = 3 [
          set payoff 0
          ask p2 [set payoff 0]]
        if s2 = 0 or s2 = 2 [
          set payoff 1
          ask p2 [set payoff 1]]]

      if local-sex = 1 [
        if s2 = 0 or s2 = 2 [
          set payoff 0
          ask p2 [set payoff 0]]
        if s2 = 1 or s2 = 3 [
          set payoff 1
          ask p2 [set payoff 1]]]]

    if sex = 1 [

      if local-sex = 0 [
        if s2 = 1 or s2 = 2 [
          set payoff 0
          ask p2 [set payoff 0]]
        if s2 = 0 or s2 = 3 [
          set payoff 1
          ask p2 [set payoff 1]]]

      if local-sex = 1 [
        if s2 = 0 or s2 = 3 [
          set payoff 0
          ask p2 [set payoff 0]]
        if s2 = 1 or s2 = 2 [
          set payoff 1
          ask p2 [set payoff 1]]]]]
end


;=========================================learning rules==========================
to learn

  ; this is the decision tree for which learning mechanism the agent
  ; executes based on it's learning style and what rules are active
  ; if the model is set to use learning_styles, then the agents pick a learning
  ; algorithm based on their learning-style variable

  if learning_styles? = true [
    if learning-style = 0 [
      learn-random-partner]
    if learning-style = 1 [
      learn-same-sex-partner]
    if learning-style = 2 [
      learn-opposite-sex-partner]]

  ; if the model is set to use gender_learning then every agent
  ; executes learn from a partner of the same sex

  if gendered_learning? = true [
    learn-same-sex-partner]

  ; if neither gender_learning or learning_styles are active,
  ; the agents learn from a random partner

  if gendered_learning? = false and learning_styles? = false [
    learn-random-partner]

  ; and if both are active, it results in an error

  if gendered_learning? = true and learning_styles? = true [
    error "inconsistent learning mechanisms are active"]
end

to learn-random-partner

  ; the agent picks another random agent.
  ; if the second agent got a higher payoff on the last round,
  ; the first agent switches to the strategy of the second.

  let teacher one-of other turtles
  let s2 [strategy] of teacher
  let training-data [payoff] of teacher
  if training-data > payoff [
    set strategy s2]
end

to learn-same-sex-partner

  ; same as above except it pick a random agent of the same sex

  let local-sex sex
  let teacher one-of other turtles with [sex = local-sex]
  let s2 [strategy] of teacher
  let training-data [payoff] of teacher
  if training-data > payoff [
    set strategy s2]
end

to learn-opposite-sex-partner

  ; same - picks an agent of the opposite sex

  let local-sex sex
  let teacher one-of other turtles with [sex != local-sex]
  let s2 [strategy] of teacher
  let training-data [payoff] of teacher
  if training-data > payoff [
    set strategy s2]
end

;=============================================Misc================================

to learn-learning-style

  ; the agent picks a random agent and copies their
  ; learning style if the second agent received
  ; a higher score on the previous round

  let teacher one-of other turtles
  let ls2 [learning-style] of teacher
  let training-data [payoff] of teacher
  if training-data > payoff [
    set learning-style ls2]
end

to mutate

  ; with some user-controlled probability, the agents switch to a new random strategy
  ; if the model is set to use type-conditional strategies, there they have can
  ; mutate any of the four strategies
  ; otherwise they just mutate the light and dark blue strategies

   ifelse type-players? = true
    [let strategies 4
     if random 10000 < (100 * mutation_rate) [
       set strategy random strategies]]
    [let strategies 2
     if random 10000 < (100 * mutation_rate) [
       set strategy random strategies]]

end

to mutate-ls

  ; if the agents are using learning_styles, they also have a user-controlled
  ; probability of switching their learning_style.

  if random 10000 < (100 * mutation_learning_styles) [
    set learning-style random 3]
end

to recolor

  ; manages the visualization

  if strategy = 0 [set color 94]
  if strategy = 1 [set color 86]
  if strategy = 2 [set color 26]
  if strategy = 3 [set color 15]
end

;================reporters================

to-report global-average-payoff
  report (sum [payoff] of turtles) / (count turtles + .01)
end

to-report success
  report global-average-payoff > .75 and count turtles = count turtles with [learning-style = 1]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
348
149
-1
-1
13.0
1
10
1
1
1
0
0
0
1
0
9
0
9
1
1
1
ticks
30.0

BUTTON
16
35
79
68
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
87
35
150
68
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
17
272
190
305
mutation_rate
mutation_rate
0
100
0.0
.01
1
perceent
HORIZONTAL

TEXTBOX
208
156
382
247
dark blue = always A\nlight blue = always B\norange = a vs males/b vs females\nburgandy = b vs males/a vs females\ncircle = male\nbox = female
10
0.0
1

SWITCH
16
236
181
269
gendered_learning?
gendered_learning?
1
1
-1000

PLOT
376
167
576
317
Average payoff
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"set-plot-y-range 0 1" ""
PENS
"default" 1.0 0 -16777216 true "" "plot global-average-payoff"
"pen-1" 1.0 0 -3026479 true "" "plot .5"

SWITCH
15
73
147
106
type-players?
type-players?
1
1
-1000

PLOT
377
11
577
161
Strategy frequency
NIL
NIL
0.0
10.0
0.0
100.0
true
false
"plot-pen-up" "if ticks > 1 [plot-pen-down]"
PENS
"default" 1.0 0 -14454117 true "" "plot count turtles with [strategy = 0]"
"pen-1" 1.0 0 -8990512 true "" "plot count turtles with [strategy = 1]"
"pen-2" 1.0 0 -817084 true "" "plot count turtles with [strategy = 2]"
"pen-3" 1.0 0 -2674135 true "" "plot count turtles with [strategy = 3]"

SLIDER
16
111
195
144
initial-light-blue
initial-light-blue
0
100
25.0
1
1
percent
HORIZONTAL

SLIDER
16
148
188
181
initial-orange
initial-orange
0
100
25.0
1
1
percent
HORIZONTAL

SLIDER
16
184
197
217
initial-burgandy
initial-burgandy
0
100
25.0
1
1
percent
HORIZONTAL

SWITCH
18
323
162
356
learning_styles?
learning_styles?
1
1
-1000

SLIDER
18
359
230
392
mutation_learning_styles
mutation_learning_styles
0
100
0.0
.01
1
percent
HORIZONTAL

PLOT
583
11
783
161
learning styles
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"set-plot-x-range 0 3\nset-plot-y-range 0 100\nset-histogram-num-bars 3" ""
PENS
"default" 1.0 1 -16777216 true "" "if learning_styles? = true [histogram [learning-style] of turtles]"

PLOT
584
168
784
318
frequency of gendered learning
NIL
NIL
0.0
10.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles with [learning-style = 1]"

MONITOR
791
11
854
56
Success?
success
17
1
11

TEXTBOX
795
74
945
116
left = indiscriminate learning\nmiddle = same-sex learning\nright = opposite-sex learing
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

A model that represents the cultural evolution of gender. This model is specifically interested in exploring the co-evolution of gendered behaviour and gendered social learning.

Some tasks are best completed through a specialized division of labour. But without social roles, it can be difficult to coordinate on the issue of who should perform which tasks. Who should fish and who should make pottery? Sexual differences are one salient feature in early human societies that could provide a basis for the division of labour. The hypothesis is agents will tend to form gendered conventions as devices to enable coordination.

## HOW IT WORKS

The agents repeatedly play a game that represents a division of labour problem. The intuitive idea behind the game is that when people pick different tasks and share/trade the results, they both do better. Specialized divisions of labour improve efficiency and allow people to get a more diverse range of goods. The game has the the following structure:

		A	B
	A	0,0	1,1
	B	1,1	0,0

So when two agents take opposite but complimentary actions, they get a payoff that represents the gains due to specialization and/or diversificaton. But absent some convention about who should do A and who should do B, there is only a 50-50 chance they coordinate. However, if the population can develop a convention, they can improve their performance.

The agents are coloured according their strategy.

	Dark blue	always perform action A
	Light blue	always perform action B
	Orange		perform action A vs males and B vs females
	Burgandy	perform action B vs males and A vs females

The agents' shape (and location) represents their sex. The circles at the top are females while the squares at the bottom are males.

One of the quintessential features of gender is that it specifies how we should interactions with people of the other gender. We have conventions about how to divide household labour, conventions about who asks whom out on a first date, conventions about who holds the door open for whom. Whenever there is one characteristic action played by females and another by males, we interpret that model behaviour as representing a gendered convention.

In the model, agents take five actions per round:

**Play** - Agents pick a random partner and play the coordination game. If they play complementary (A-B or B-A) strategies, they get a payoff of 1. Otherwise, they get a payoff of 0.

**Learn strategy** - Agents pick a new partner based on their learning style [any, same-sex, opposite-sex]. If their partner received a higher payoff, they switch to playing their strategy.

**Mutate strategy** – Agents have a small probability of randomly switching to a new strategy. The mutation rate is controlled by a slider.

_optional_
**Update learning style** – Agents pick a new random partner. If the partner received a higher payoff, the agent switches to their partner's learning style.

**Mutate learning style** – Agents have a small probability of randomly switching to a new learning style. This rate is also controlled by a slider.


## HOW TO USE IT

Set up clears all the previous data and creates a new population with a distribution of properties according to a mix of random variables and user-defined parameters.

Go commands the agents to repeatedly take the 5 actions noted above. The basic procedure is to set up the model under various conditions and then let the model run until it reaches some stable equilibrium behaviour. You are usually looking to see what kind of average payoff the model achieves but you may also be interested in the frequencies and distribution of strategies across each sex group.

Setting the type_players? switch to 'on' enables the orange and burgandy strategies described above. This allows the user to easily explore the effect of allowing agents to conditionalize their action on the other player's sex.

The 3 sliders (initial light blue, initial orange and initial burgandy) control what percentage of the initial population starts with any strategy. Whatever percentage of the population that is not specified by the sliders is dark blue. This allows the user to explore whether the behaviour is sensitive to different starting conditions and whether certain strategies can invade via mutations. (If the three sliders sum to more than 100% of the population, you should get a runtime error.)

Setting gendered_learning? to 'on' changes the **learn strategy** rule. Now agents only select agents of the same sex to imitate. Use this setting to represent the situation where agents engage in gendered social learning.

The mutation_rate slider controls the probability that a given agent switches to a new random strategy whenever the execute the **mutate strategy** action.

Setting learning_styles? to 'on' and then pressing setup configures a model where all the agents have a randomly assigned learning style that indicates what type of agent that pick to imitate (same-sex, opposite-sex, indiscriminately) during **learn strategy**. Enable this setting to model the process by which gendered social learning can evolve. (You cannot have both gendered_learning and learning_styles? on at the same time.)

The mutation_learning_styles slider controls the probability agents randomly change their learning style. It only works when learning styles are enabled.

## THINGS TO NOTICE

There are four interesting configures to explore with this model.

First, turn everything off. This represent a kind of baseline case - the agents have no gendered behaviour at all. They only play simple strategies (light blue and dark blue) and try to coordinate as best they can. The result is they play no better than chance. Half the time they coordinate and effectively divide labour. Half the time they take the same action and ineffecitvely divide labour. This is indicated by the average payoff graph that flucuates around .5.

Second, turn on the type-players and gendered social learning. If you run the model, you should notice the average payoff rises to .75. This represents the case where the agents form a gendered convention. This confirms the idea that agents can improve their coordination by using sex as a way to assign roles to each player.  This is an agent-based implementation of a model Cailin O'Connor explores using the two-population replicator dynamics (reference below, chapter 3).

Third, turn off gendered social learning but leave type-players on. This represents the situation where agents can engage in gendered interaction but do not have a special mechanism for distributing their strategies by sex. The result is surprising - the agents coordinate better than in the first case but worse than in the second case. Their average payoff flucuates around .62, representing a kind of intermediate case.

Fourth, turn on learning styles. This represents an environment in which gendered social learning and strategic interactions can co-evolve. In most trials, gendered learning takes over and population and the average payoff rises to .75.

## CREDITS AND REFERENCES

by Daniel Saunders, University of British Columbia, Department of Philosopy
supervision from Chris Stephens
closely based on work by Cailin O'Connor, described in the book The Origins of Unfairness:

https://oxford.universitypressscholarship.com/view/10.1093/oso/9780198789970.001.0001/oso-9780198789970
DOI:10.1093/oso/9780198789970.001.0001
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="even strategy distribution" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>success</exitCondition>
    <metric>success</metric>
    <enumeratedValueSet variable="initial-blue">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-green">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="type-players?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-yellow">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_rate">
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="learning_styles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_learning_styles">
      <value value="0.01"/>
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="from scratch - low mutation rates" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>success</exitCondition>
    <metric>success</metric>
    <enumeratedValueSet variable="type-players?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-blue">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-green">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-yellow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_rate">
      <value value="0.01"/>
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="learning_styles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_learning_styles">
      <value value="0.01"/>
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="from scratch - high mutation rates" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>success</exitCondition>
    <metric>success</metric>
    <enumeratedValueSet variable="type-players?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-blue">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-green">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-yellow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_rate">
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="learning_styles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_learning_styles">
      <value value="0.01"/>
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="from scratch - high ls mutation rate" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>success</exitCondition>
    <metric>success</metric>
    <enumeratedValueSet variable="type-players?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-blue">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-green">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-yellow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_rate">
      <value value="0.01"/>
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="learning_styles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_learning_styles">
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="even strategy distribution part 2" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>success</exitCondition>
    <metric>success</metric>
    <enumeratedValueSet variable="initial-blue">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-green">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="type-players?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-yellow">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_rate">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.05"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="learning_styles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_learning_styles">
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="even strategy distribution-part 7" repetitions="900" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>success</exitCondition>
    <metric>success</metric>
    <enumeratedValueSet variable="initial-blue">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-green">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="type-players?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-yellow">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_rate">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="learning_styles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_learning_styles">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="even strategy distribution-part 6" repetitions="1000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>success*</exitCondition>
    <metric>success*</metric>
    <enumeratedValueSet variable="initial-blue">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-green">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="type-players?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-yellow">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_rate">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="learning_styles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation_learning_styles">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
