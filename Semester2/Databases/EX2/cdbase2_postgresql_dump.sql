--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1 (Debian 14.1-1.pgdg110+1)
-- Dumped by pg_dump version 14.1 (Debian 14.1-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: cdbase2; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA cdbase2;


ALTER SCHEMA cdbase2 OWNER TO root;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cd; Type: TABLE; Schema: cdbase2; Owner: root
--

CREATE TABLE cdbase2.cd (
    cid integer NOT NULL,
    ctitle character varying(100),
    year integer,
    comid integer
);


ALTER TABLE cdbase2.cd OWNER TO root;

--
-- Name: company; Type: TABLE; Schema: cdbase2; Owner: root
--

CREATE TABLE cdbase2.company (
    comid integer NOT NULL,
    name character varying(45)
);


ALTER TABLE cdbase2.company OWNER TO root;

--
-- Name: performer; Type: TABLE; Schema: cdbase2; Owner: root
--

CREATE TABLE cdbase2.performer (
    pid integer NOT NULL,
    name character varying(100)
);


ALTER TABLE cdbase2.performer OWNER TO root;

--
-- Name: song; Type: TABLE; Schema: cdbase2; Owner: root
--

CREATE TABLE cdbase2.song (
    sid integer NOT NULL,
    stitle character varying(255)
);


ALTER TABLE cdbase2.song OWNER TO root;

--
-- Name: track; Type: TABLE; Schema: cdbase2; Owner: root
--

CREATE TABLE cdbase2.track (
    pid integer NOT NULL,
    cid integer NOT NULL,
    sid integer NOT NULL,
    pos integer NOT NULL
);


ALTER TABLE cdbase2.track OWNER TO root;

--
-- Data for Name: cd; Type: TABLE DATA; Schema: cdbase2; Owner: root
--

COPY cdbase2.cd (cid, ctitle, year, comid) FROM stdin;
1	Genuine Houserockin' Music	1986	1
2	Genuine Houserockin' Music II	1987	1
3	Genuine Houserockin' Music III	1988	1
4	Genuine Houserockin' Music IV	1990	1
5	Genuine Houserockin' Music V	1993	1
6	Prime Chops	1990	2
7	Prime Chops Volume 2	1993	2
8	Prime Chops Volume 3	1996	2
9	Blues-A-Rama	1990	3
10	Blues Pajama Party	1992	3
11	Soul Survey	1992	3
12	Vocal Dynamite!	1996	3
13	Instrumental Blues Dynamite!	1996	3
14	Atlantic Blues: Piano	1986	4
15	20th Anniversary Collection	1991	1
16	20th Anniversary Collection	1991	1
17	25th Anniversary Collection	1996	1
18	25th Anniversary Collection	1996	1
19	Atlantic Blues: Guitar	1986	4
20	Atlantic Blues: Vocalists	1986	4
21	Atlantic Blues: Chicago	1986	4
22	Canned Heat Blues: Masters Of The Delta Blues	1992	5
23	Direct Hits From Bullseye Blues	1993	6
24	Chess Blues 1- 1947-1952	1992	7
25	Chess Blues 2 - 1952-1954	1992	7
26	Chess Blues 3 - 1954-1960	1992	7
27	Chess Blues 4 - 1960-1967	1992	7
28	Kingfish	2019	1
29	Best of Muddy Waters	2010	1
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: cdbase2; Owner: root
--

COPY cdbase2.company (comid, name) FROM stdin;
1	Alligator Records
2	Blind Pig Records
3	Black Top
4	Atlantic
5	BMG-Bluebird
6	Bullseye Blues
7	Chess
\.


--
-- Data for Name: performer; Type: TABLE DATA; Schema: cdbase2; Owner: root
--

COPY cdbase2.performer (pid, name) FROM stdin;
1	Kingfish
2	Johnny Winter 
3	Koko Taylor
4	Lonnie Mack
5	Collins Albert/Cray Robert/Copeland Johnny
6	Son Seals
7	Lonnie Brooks
8	Roy Buchanan
9	Fenton Robinson
10	Jimmy Johnson
11	James Cotton
12	Hound Dog Taylor and the Houserockers
13	Albert Collins
14	Big Twist and the Mellow Fellows
15	Lil' Ed and the Blues Imperials
16	Little Charlie and the Nightcats
17	Donald Kinsey & The Kinsey Report
18	James Cotton and His Big Band
19	Buchanan Roy/McClinton Delbert
20	Clarence \\"Gatemouth\\" Brown
21	Professor Longhair
22	Buddy Guy
23	Professor's Blues Review with Hardiman Gloria
24	Cray Robert/Collins Albert
25	Elvin Bishop
26	Katie Webster
27	The Paladins
28	A.C. Reed
29	Kenny Neal
30	The Kinsey Report
31	Maurice John Vaughn
32	Tinsley Ellis
33	The Siegel-Schwall Band
34	Rufus Thomas
35	Lazy Lester
36	Lucky Peterson
37	Charlie Musselwhite
38	Delbert McClinton
39	Charles Brown
40	Sonny Boy Williamson II
41	William Clarke
42	Saffire-The Uppity Blues Women
43	Cotton James/Wells Junior/Bell Carey/Branch Billy
44	Billy Boy Arnold
45	Johnny Heartsman
46	Steady Rollin' Bob Margolin
47	Big Daddy Kinsey & Sons
48	Hubert Sumlin
49	Joanna Connor
50	Otis Rush
51	Pinetop Perkins
52	Mr. B/Heard J.C.
53	Mitch Woods And His Rockets 88s
54	Henry Gray
55	Roy Rogers
56	Snooky Pryor
57	Yank Rachell
58	Big Walter Horton
59	Guy Buddy/Wells Junior
60	Debbie Davis
61	Jimmy Thackery And The Drivers
62	Carey Bell
63	Rogers Roy/Buffalo Norton
64	Gospel Hummingbirds
65	Little Mike And The Tornadoes
66	Eddy Clearwater
67	Roosevelt Sykes
68	John Mooney
69	Shines Johnny/Pryor Snooky
70	Al Rapone
71	Chris Cain Band
72	Deanna Bogart
73	Magic Slim
74	Otis Clay
75	Coco Montoya
76	Jimmy Rogers
77	Chris Cain
78	John Studebaker And The Hawks
79	Smokey Wilson
80	Frankie Lee
81	E.C. Scott
82	Preacher Boy And The Natural Blues
83	Luther Allison
84	Thackery Jimmy/Mooney John
85	Eddie C. Campbell
86	Willie \\"Big Eyes\\" Smith
87	Chubby Carrier
88	Ron Levy
89	Bobby Radcliff
90	Nappy Brown
91	Snooks Eaglin
92	Earl King
93	The Neville Brothers
94	Grady Gaines And The Texas Upsetters/Medwick Joe
95	Ronnie Earl And The Broadcasters
96	James \\"Thunderbird\\" Davis
97	The Tri-Saxual Soul Champs
98	Carol-Fran-Clarence Hollimon
99	Mike Morgan And The Crawl
100	Copley Al/Singer Hal/Eaglin Snooks
101	Joe \\"Guitar\\" Hughes
102	Funderburgh Anson And The Rockets/Myers Sam
103	Buckwheat Zydeco
104	Greg Piccolo
105	Lynn August
106	Robert Ward
107	Rod Piazza And The Mighty Flyers
108	King Earl/Roomful Of Blues/Salgado Curtis
109	Carol Fran
110	Sil Austin
111	Sumlin Hubert/McClain Mighty Sam
112	James Harman Band
113	Ward Robert/The Black Top All-Stars
114	Morgan Mike And The Crawl/McBee Lee
115	Fran Carol/Hollimon Clarence
116	Reynolds Teddy/Gaines G. And The Texas Upsetters
117	Darrell Nulisch And Texas Heat
118	Grady Gaines And The Texas Upsetters
119	Grady \\"Fats\\" Jackson
120	Kim Wilson
121	Joe Medwick
122	Tommy Ridgley
123	Muldaur Maria/Dr. John
124	Phillip Walker
125	Big Joe And The Dynaflows
126	Bobby Parker
127	Sam Myers
128	Lee McBee
129	Rick Holmstrom
130	Al Copley
131	Rusty Zinn
132	Anson Funderburgh And The Rockets
133	Guitar Shorty
134	Clarence Hollimon
135	Solomon Burke
136	Jimmy Yancey
137	Little Brother Montgomery
138	Champion Jack Dupree
139	Vann \\"Piano Man\\" Walls
140	Big Joe Turner
141	Jay McShann
142	Meade Lux Lewis
143	Ray Charles
144	Floyd Dixon
145	Texas Johnny Brown
146	Dr. John
147	Willie Mabon
148	Collins Albert/Copeland Johnny
149	Reed A.C./Vaughan Stevie Ray
150	Detroit Junior
151	Bell Carey/Wells Junior
152	Sonny Terry
153	Clifton Chenier
154	C.J. Chenier And The Red Hot Louisiana Band
155	Eddie Shaw And The Wolf Gang
156	Cephas & Wiggins
157	Long John Hunter
158	Mack Lonnie/Vaughan Stevie Ray
159	Sugar Blue
160	Dave Hole
161	Corey Harris
162	Michael Hill's Blues Mob
163	Blind Willie McTell
164	Mississippi Fred McDowell
165	John Lee Hooker
166	Stick McGhee
167	T-Bone Walker
168	Chuck Norris
169	Guitar Slim
170	Cornell Dupree
171	Al King
172	Mickey Baker
173	Ike & Tina Turner
174	B.B. King
175	Albert King
176	John Hammond Jr.
177	Stevie Ray Vaughan
178	Sippie Wallace
179	Jimmy Witherspoon
180	LaVern Baker
181	Mama Yancey
182	Lil Green
183	Wynonie Harris
184	Ruth Brown
185	Percy Mayfield
186	Ted Taylor
187	Esther Phillips
189	Titus Turner
190	Bobby Blue Bland
191	Eldridge Holmes
192	Johnny Taylor
193	Aretha Franklin
194	Z.Z. Hill
195	Johnny Copeland
196	Johnny Jones
197	Freddie King
198	Howlin' Wolf
199	Johnny Shines
200	Luther \\"Guitar Jr.\\" Johnson
201	J.B. Hutto
202	Muddy Waters
203	Furry Lewis
204	Tommy Johnson
205	Ishman Bracey
206	Lowell Fulson
207	Smokin' Joe Kubek Band Smokin' Joe/King B'Nois
208	Brown Charles/Raitt Bonnie
209	Nocturne Band Johnny/Boykin Brenda
210	Byther Smith
211	Eddie Hinton
212	Clay Otis/Fountain Clarence
213	Peebles Ann/King Little Jimmy
214	Larry Davis
215	Johnny Talbot
216	Levy's Wild Kingdom Ron/Collins Albert
217	Dalton Reed
218	Paul Kelly
219	McCracklin Jimmy/Thomas Irma
220	Omar And The Howlers
223	Clarence Samuels
224	Andrew Tibbs
225	Sunnyland Slim
226	Robert Nighthawk
227	St. Louis Jimmy
228	Forest City Joe
229	Forrest Sykes
230	Laura Rucker
231	Baby Face Leroy
232	Little Johnny Jones
233	Memphis Slim
234	Dr. Isaiah Ross
235	Arbee Stidham
236	Little Walter
237	Memphis Minnie
238	Willie Nix
239	Rocky Fuller
240	Eddie Boyd
241	Gus Jenkins
242	John Brim
243	Elmore James
245	Alberta Adams
246	Gray Henry/Pejoe Morris
247	J.B. Lenoir
248	Willie Dixon
249	Gayten Paul/Jones Myrtle
250	Otis Spann
251	Lafayette Leake
253	Lloyd Glenn
254	Little Milton
255	Little Joe Blue
256	Eddie Burns
257	Etta James
258	The Big Three Trio
\.


--
-- Data for Name: song; Type: TABLE DATA; Schema: cdbase2; Owner: root
--

COPY cdbase2.song (sid, stitle) FROM stdin;
1	Sound The Bell
2	Come To Mama
3	Satisfy Suzie
4	Blackjack
5	Goin' Home
6	Don't Take Advantage Of Me
7	Short Fuse
8	Laundry Man
9	You Don't Know What Love Is
10	Ain't Doin' Too Bad
11	Don't Blame Me
12	I Ain't Drunk
13	The Sweet Sound Of Rhythm And Blues
14	I'd Rather Go Blind
15	Pride And Joy
16	T.V. Crazy
17	Corner Of The Blanket
18	Mojo Boogie
19	Boomerang
20	Tough On Me, Tough On You
21	Part Time Love
22	The Chokin' Kind
23	Pressure Cooker
24	It's My Fault, Darling
25	She's Out There Somewhere
26	Meet Me With Your Black Drawers On
27	The Dream
28	Don't Lie To Me
29	Who's Making Love?
30	Years Since Yesterday
31	She's Fine
32	High Wire
33	Two Headed Man
34	Outside Looking In
35	I Ain't Lyin'
36	Poor Man's Relief
37	Girl Don't Live Here
38	Can't You Lie
39	I Think It Was The Wine
40	That Woman Is Poison
41	Take Me In Your Arms
42	Over My Head
43	Got My Mojo Working
44	Natural Disaster
45	River Hip Mama
46	Time Will Tell
47	Chicken, Gravy And Biscuits
48	B Movie Boxcar Blues
49	I Stepped In Quicksand
50	Midnight Drive
51	The Son I Never Knew
52	Don't Do It
53	Two-Fisted Mama
54	Pawnbroker
55	I Can't Understand
56	Your Lies
57	Rollin' With My Blues
58	Lollipop Mama
59	Silent Thunder In My Heart
60	I Don't Believe
61	Down Home Blues
62	Don't Put Your Hands On Me
63	I Wish You Would
64	Stealin' Watermelons
65	I'm Bad
66	My Next Ex-Wife
67	Paint My Mailbox Blue
68	Don't Treat Your Man Like A Dog
69	Stop Time
70	Highwayman
71	Pawnshop Bound
72	Older Woman
73	While You're Down There
74	Right Train, Wrong Track
75	Watching Your Watch
76	Feast Or Famine
77	Hear Me Talkin'
78	Bad Axe
79	Can't Let Go
80	Bring Your Love To Me
81	When You're Being Nice
82	Crosscut Saw
83	Sit In the Easy Chair
84	He May Be Your Man
85	Broke
86	Gray's Bounce
87	Walkin' Blues
88	My Babe
89	Nine Below Zero
90	My Baby's Gone
91	Hard Hearted Woman
92	Messing With The Kid
94	Last Night
95	Mellow Down Easy
96	Texas
97	Ain't No Bread In The Breadbox
98	Judgement Day
99	What About Love
100	Crossover
101	Too Smart Too Soon
102	Take A Walk Around The Corner
103	Cool Driver
104	Yvette U.B. Dancin'
105	Solid Gold Cadillac
106	Pick Up The Tab
107	Walter's Swing
108	Black Cat Bone
109	Beat Me Daddy (Eight To The Bar)
110	Cold Women With Warm Hearts
111	Have Mercy Jesus
112	Gotta Mind To Travel
113	Rock This House
114	Wrong Man For Me
115	Trouble Man
116	You're Gonna Need Somebody On Your Bond
117	Pistol In Your Face
118	Don't Let The Same Dog Bite You Twice
119	For Lovin' You
120	Howlin' For My Darlin'
121	Great Change
122	What's The Matter Baby
123	Shakin' The Shack
124	I've Got Love On The Line
125	Dead, Boy
126	Serious
127	Oh Louise
128	That's When I Know
129	Tell Me Mama
130	Turn On Your Love Light
131	Chicken Fried Snake
132	Ugh!
133	Dirty Work
134	Mary Joe
135	Out Of Nowhere
136	Old Mr. Bad Luck
137	Woman's Gotta Have It
138	I Don't Want To Hear About Yours
139	If I Don't Get Involved
140	I Want To Shout About It
141	Check Out Time
142	Come By Here
143	Go Girl!
144	Emmitt Lee
145	Pretty Woman
146	Boogie Woogie On MKT
147	If You Want To See The Blues
148	20 Miles
149	Buck's Nouvelle Jolie Blon
150	The Hammer
151	Life's Ups And Downs
152	Zydeco Shoes
153	Hey Lucille
154	Bonehead Too
155	That Same Old Train
156	All Your Love
157	Potato Soup
158	I'm Gonna Cry A River
159	Deep Fried
160	Please Don't Leave Me Here To Cry
161	All Of My Life
162	If I Had My Life To Live Over
163	Sil's Crecent City Groove
164	Meet Me At The Bottom
165	Got News
166	Bad, Bad Boy
167	Love Is The Way Of Life
168	Mushmouth
169	I'll See You In My Dreams/Mr. Sandman
170	Your Love Is Amazing
171	May Be The Last Time
172	Low Down Dog
173	Mad About Something
174	Kiss Me Baby
175	Teasin' You
176	Always The First Time
177	Brother Jug's Sermon
178	I've Been Out There
179	Golden Girl
180	Lilly Mae
181	Shaggy Dog
182	Count On Me
183	When I Woke Up
184	The Dark End Of The Street
185	Tell Me What I Want To Hear
186	Blind Love
187	Cherry Race
188	Toehold
189	Coffee Break Blues
190	Along About Midnight
191	Undivided Love
192	So Many Roads
193	Your Girlfriend
194	Shack Up With Me
195	Best Of Me
196	The Four Questions
197	Special Built Woman
198	Ever Since The World Began
199	Seduction
200	Kick It Around With You
201	Tomorrow Will Find Me The Same Way
202	I Should've Done Better
203	I'll Never Be Free
204	Nine Pound Steel
205	Torqueflite
206	Fooled Ya
207	Misirlou
208	You And Me
209	Bobby-Q
210	Glass Boogie
211	Blessings
212	Jr. Jives
213	Down At J.J.'s
214	Big D Shuffle
215	Old Time Sake
216	Bonehead
217	Night's End
218	Smells Like Bar-B-Q
219	Elegie
220	Gristle's Improvisations
221	Yancey Special
222	Talkin' Boogie
223	Mournful Blues
224	Salute To Pinetop
225	Shave 'Em Dry
226	Frankie & Johnny
227	T.B. Blues
228	Strollin'
229	Tipitina
230	Blue Sender
231	After Midnight
232	Roll 'Em Pete
233	Fore Day Rider
234	My Chile
235	Cow Cow Blues
236	Albert's Blues
237	Honky Tonk Train Blues
238	Low Society
239	Hey Bartender
240	Floyd's Blues
241	After Hours Blues
242	Junco Partner
243	I Don't Know
244	Give Me Back My Wig
245	No Cuttin' Loose
246	Big Chief
247	That's Why I'm Crying
248	Double Eyed Whammy
249	I'm Free
250	These Blues Is Killing Me
251	Rain
252	Look But Don't Touch
253	Fannie Mae
254	Serves Me Right To Suffer
255	Leavin'
256	Born In Louisiana
257	Leaving Your Town
258	Drowning On Dry Land
259	If I Hadn't Been High
260	Trouble In Mind
261	Brick
262	Pussycat Moan
263	You Don't Exist Any More
264	Second Hand Man
265	I've Got Dreams To Remember
266	Going Down To Big Mary's
267	300 Pounds Of Heavenly Joy
268	Going Back Home
269	Strike Like Lightning
270	The Middle Aged Blues Boogie
271	Eyeballin'
272	Full Moon On Main Street
273	Crow Jane
274	I'm The Zydeco Man
275	Blues After Hours
276	Boot Hill
277	Don't Pick Me For Your Fool
278	Digging My Potatoes
279	Something To Remember You By
280	The Complainer's Boogie Woogie
281	Stingaree
282	It's Alright
283	Man Smart, Woman Smarter
284	I Want To Be Your Spy
285	Sitting On The Top Of The World
286	Action Man
287	Bayou Blood
288	T-Bone Intentions
289	T'Aint Nobody's Business
290	If You Have To Know
291	Been Gone Too Long
292	A Quitter Never Wins
293	I Ain't Got You
294	Crawfish Fiesta
295	Evil
296	Got Lucky Last Night
297	Blues Lover
298	I Could Deal With It
299	Cherry Red Wine
300	Hard Lovin' Mama
301	She Puts Me In The Mood
302	Low Down Dirty Shame
303	Six O'Clock Blues
304	Keep Your Motor Running
305	Roots Woman
306	Can't Recall A Time
307	Baby, Baby, Baby
308	Jack The Ripper
309	The Sky Is Crying
310	Love, Life And Money
311	Look On Yonder's Wall
312	Somebody Loan Me A Dime
313	We're Outta Here
314	Broke Down Engine
315	Shake Em' On Down
316	My Baby Don't Love Me
317	Tall Pretty Woman
318	The Blues Rock
319	There Goes The Blues
320	Bongo Boogie
321	Two Bones And A Pick
322	Let Me Know
323	Down Through The Years
324	Okie Dokie Stomp
325	TV Mama
326	Reconsider Baby
327	Midnight Midnight
328	I Smell Trouble
329	Why I Sing The Blues
330	Born Under A Bad Sign
331	Shake For Me
332	Flood Down In Texas
333	Suitcase Blues
334	In The Evenin'
335	Gimme A Pigfoot
336	How Long Blues
337	Oke-She-Moke-She-Pop
338	I've Got That Feelin'
339	Every Time
340	Destination Love
341	Tell A Whale Of A Tale
342	Rain Is A Bringdown
343	Nothing Stays The Same Forever
344	River's Invitation
345	Just Like A Fish
346	Pouring Water On A Drowning Man
347	Did You Ever Love A Woman
348	Baby Girl Parts 1&2
349	Ain't That Lovin' You
350	It's My Own Tears That's Being Wasted
351	Cheatin' Woman
352	I Had A Dream
353	Takin' Another Man's Place
354	It's A Hang-Up Baby
355	Chicago Blues
356	Poor Man's Plea
357	My Baby She Left Me
358	T-Bone Shuffle
359	I Wonder Why
360	Play It Cool
361	Woke Up This Morning
362	Gambler's Blues
363	Feel So Bad
364	Reap What You Sow
365	Highway 49
366	Honey Bee
367	Wang Dang Doodle
368	Dust My Broom
369	Please Send Me Someone To Love
370	Walkin' The Dog
371	I Feel So Good
372	Furry's Blues
373	I Will Turn Your Money Green
374	Mistreatin' Mama
375	Dry Land Blues
376	Cannon Ball Blues
377	Kassie Jones Part 1
378	Kassie Jones Part 2
379	Judge Harsh Blues
380	Cool Drink Of Water Blues
381	Big Road Blues
382	Bye Bye Blues
383	Maggie Campbell Blues
384	Canned Heat Blues
385	Lonesome Home Blues
386	Big Fat Mama Blues
387	Saturday Blues
388	Left Alone Blues
389	Leavin' Town Blues
390	Brown Mama Blues
391	Trouble Hearted Blues
392	The Four Day Blues
393	Ain't That Sweet
394	Love To Live The Life
395	Someone To Love
396	Wailin'
397	I Got So Much Love
398	Poor Ol' Me
399	Send Up My Timber
400	Full Time Love
401	Help The Poor
402	Things I Used To Do
403	Come Back To Me
404	Defrostin'
405	Read Me My Rights
406	The New Rules
407	Tomorrow
408	Big Leg Emma
409	Lollypop Mama
410	Bilbo Is Dead
411	Johnson Machine Gun
412	Fly Right, Little Girl
413	Little Anna Mae
414	I Can't Be Satisfied
415	My Sweet Lovin' Woman
416	I Feel Like Going Home
417	She Ain't Nowhere
418	Florida Hurricane
419	Memory Of Sonny Boy
420	Tonky Boogie
421	Cryin' The Blues
422	My Head Can't Rest Anymore
423	Big Town Playboy
424	Sweet Black Angel
425	Rollin' Stone
426	Luedella
427	Mother Earth
428	Dr. Ross Boogie
429	Joliet Blues
430	Moanin' At Midnight
431	All Night Long (alternate)
432	Mr. Commissioner (alternate)
433	Gettin' Old And Grey
434	Walkin' The Boogie (alternate)
435	Juke
436	Conjur Man
437	Who's Gonna Be Your Sweet Man When I'm Gone
438	Broken Heart (alternate)
439	Truckin' Little Woman
440	Funeral Hearse At My Door
441	Hard Time Gettin' Started
442	Don't Need No Horse
443	Eight Ball
444	Fast Boogie
445	I'm Mad
446	Ice Cream Man
447	Whose Muddy Shoes
448	Got To Have It
449	I Declare That Ain't Right
450	Remember
451	Untitled Instrumental
452	Blues With A Feeling
453	Hoochie Coochie Man
454	Forty Four
455	Got To Find My Baby (alternate)
456	Mama Talk To Your Daughter
457	My Eyes (Keep Me In Trouble)
458	You Got To Love Me
459	Walking The Blues
460	Don't Start Me To Talkin'
461	Smokestack Lightnin'
462	29 Ways
463	Right To Love You
464	Ain't Nobody's Business
465	I'm Leaving You
466	Break Of Day
467	Please Don't Go
468	Keep It To Yourself
469	Walking By Myself
470	Fattening Frogs For Snakes (alternate)
471	Slow Leake
472	She Don't Know
473	Your Funeral And My Trial
474	Key To The Highway
475	Double Trouble (alternate)
476	Come On Home
477	The Goat (alternate)
478	So Many Roads, So Many Trains
479	First Time I Met The Blues
480	Too Poor
481	Blue Shadows
482	The Shakedown
483	The Sun Is Shining (alternate)
484	Calling On My Darling
485	The Red Rooster
486	Goin' Down Slow
487	Satisfied
488	Something's Got A Hold On Me
489	Wrinkles
490	Bring It On Home
491	Good Moanin' Blues
492	Killing Floor
493	What Kind Of Man Is That?
494	We're Gonna Make It
495	Dirty Work Goin' On
496	One Bourbon, One Scotch, One Beer
497	Jinglin' Baby
498	That's Why I Don't Mind
499	Keep It To Myself
500	Sitting Here Alone
501	Action Man
502	Outside Of This Town
503	Fresh Out
504	It Ain't Right
505	Been Here Before
506	If You Love Me
507	Love Ain't My Favorite Word
508	Listen
509	Before I'm Old
510	Believe These Blues
511	Trouble
512	Hard Times
513	That's Fine By Me
\.


--
-- Data for Name: track; Type: TABLE DATA; Schema: cdbase2; Owner: root
--

COPY cdbase2.track (pid, cid, sid, pos) FROM stdin;
2	1	1	1
3	1	2	2
4	1	3	3
5	1	4	4
6	1	5	5
7	1	6	6
8	1	7	7
9	1	8	8
10	1	9	9
11	1	10	10
12	1	11	11
13	2	12	1
14	2	13	2
3	2	14	3
15	2	15	4
16	2	16	5
17	2	17	6
2	2	18	7
7	2	19	8
4	2	20	9
18	2	21	10
19	2	22	11
20	2	23	12
21	2	24	13
22	2	25	14
23	2	26	15
24	2	27	16
25	3	28	1
26	3	29	2
27	3	30	3
28	3	31	4
8	3	32	5
7	3	33	6
29	3	34	7
16	3	35	8
30	3	36	9
31	3	37	10
32	3	38	11
33	3	39	12
34	3	40	13
35	3	41	14
36	3	42	15
20	4	43	1
4	4	44	2
37	4	45	3
3	4	46	4
15	4	47	5
38	4	48	6
39	4	49	7
30	4	50	8
29	4	51	9
16	4	52	10
26	4	53	11
32	4	54	12
40	4	55	13
36	4	56	14
25	4	57	15
41	4	58	16
42	4	59	17
27	4	60	18
43	4	61	19
3	5	62	1
44	5	63	2
25	5	64	3
26	5	65	4
16	5	66	5
45	5	67	6
42	5	68	7
20	5	69	8
32	5	70	9
41	5	71	10
15	5	72	11
46	5	73	12
29	5	74	13
31	5	75	14
7	5	76	15
37	5	77	16
6	5	78	17
47	6	79	1
48	6	80	2
49	6	81	3
50	6	82	4
51	6	83	5
52	6	84	6
53	6	85	7
54	6	86	8
55	6	87	9
11	6	88	10
56	6	89	11
57	6	90	12
58	6	91	13
59	6	92	14
60	7	6	1
61	7	94	2
62	7	95	3
49	7	96	4
63	7	97	5
64	7	98	6
65	7	99	7
66	7	100	8
67	7	101	9
68	7	102	10
69	7	103	11
70	7	104	12
53	7	105	13
71	7	106	14
58	7	107	15
55	7	108	16
72	7	109	17
73	7	110	18
74	7	111	19
75	8	112	1
76	8	113	2
60	8	114	3
61	8	115	4
63	8	116	5
37	8	117	6
77	8	118	7
78	8	119	8
79	8	120	9
64	8	121	10
80	8	122	11
53	8	123	12
81	8	124	13
82	8	125	14
83	8	126	15
84	8	127	16
85	8	128	17
86	8	129	18
87	8	130	19
88	9	131	1
89	9	132	2
90	9	133	3
91	9	134	4
91	9	135	5
92	9	136	6
93	9	137	7
48	9	138	8
94	9	139	9
95	9	140	10
96	9	141	11
96	9	142	12
97	9	143	13
98	9	144	14
99	9	145	15
100	9	146	16
101	9	147	17
102	9	148	18
103	9	149	19
104	9	150	20
92	9	151	21
105	10	152	1
105	10	153	2
95	10	154	3
91	10	155	4
89	10	156	5
106	10	157	6
106	10	158	7
107	10	159	8
108	10	160	9
109	10	161	10
96	10	162	11
110	10	163	12
111	10	164	13
112	10	165	14
107	10	166	15
92	10	167	16
104	10	168	17
91	10	169	18
113	11	170	1
89	11	171	2
107	11	172	3
112	11	173	4
114	11	174	5
91	11	175	6
92	11	176	7
104	11	177	8
118	11	178	9
115	11	179	10
91	11	180	11
116	11	181	12
117	11	182	13
105	11	183	14
96	11	184	15
102	11	185	16
95	11	186	17
97	11	187	18
106	12	188	1
119	12	189	2
135	12	190	3
105	12	191	4
120	12	192	5
121	12	193	6
122	12	194	7
123	12	195	8
112	12	196	9
124	12	197	10
125	12	198	11
92	12	199	12
126	12	200	13
127	12	201	14
128	12	202	15
109	12	203	16
91	12	204	17
112	13	205	1
129	13	206	2
97	13	207	3
91	13	208	4
126	13	209	5
130	13	210	6
106	13	211	7
131	13	212	8
104	13	168	9
132	13	213	10
99	13	214	11
133	13	215	12
89	13	216	13
107	13	217	14
125	13	218	15
130	13	219	16
134	13	220	17
136	14	221	1
137	14	222	2
136	14	223	3
136	14	224	4
136	14	225	5
138	14	226	6
138	14	227	7
138	14	228	8
21	14	229	9
139	14	230	10
139	14	231	11
140	14	232	12
141	14	233	13
141	14	234	14
142	14	235	15
142	14	236	16
142	14	237	17
143	14	238	18
144	14	239	19
144	14	240	20
145	14	241	21
146	14	242	22
147	14	243	23
12	15	244	1
11	15	245	2
148	15	108	3
21	15	246	4
3	15	247	5
32	15	248	6
36	15	249	7
149	15	250	8
16	15	251	9
29	15	252	10
25	15	253	11
10	15	254	12
33	15	255	13
20	15	256	14
37	15	257	15
8	15	258	16
150	15	259	17
58	15	260	18
13	16	261	1
26	16	262	2
15	16	263	3
151	16	264	4
38	16	265	5
27	16	266	6
14	16	267	7
6	16	268	8
4	16	269	9
42	16	270	10
7	16	271	11
30	16	272	12
152	16	273	13
153	16	274	14
9	16	9	15
51	16	275	16
2	16	276	17
6	17	277	1
11	17	278	2
148	17	279	3
41	17	280	4
37	17	281	5
15	17	282	6
154	17	283	7
31	17	284	8
144	17	239	9
155	17	285	10
156	17	286	11
29	17	287	12
157	17	288	13
42	17	289	14
158	17	290	15
44	17	291	16
32	17	292	17
159	17	293	18
21	17	294	19
3	18	295	1
7	18	296	2
46	18	297	3
16	18	298	4
83	18	299	5
26	18	300	6
25	18	301	7
62	18	302	8
36	18	303	9
160	18	304	10
161	18	305	11
162	18	306	12
19	18	307	13
8	18	308	14
40	18	309	15
2	18	310	16
12	18	311	17
9	18	312	18
20	18	313	19
163	19	314	1
164	19	315	2
165	19	316	3
166	19	317	4
145	19	318	5
145	19	319	6
145	19	320	7
167	19	321	8
168	19	322	9
169	19	323	10
170	19	324	11
140	19	325	12
171	19	326	13
172	19	327	14
173	19	328	15
174	19	329	16
175	19	82	17
175	19	330	18
176	19	331	19
177	19	332	20
178	20	333	1
179	20	260	2
179	20	334	3
180	20	335	4
181	20	336	5
140	20	337	6
182	20	338	7
182	20	339	8
183	20	340	9
183	20	341	10
184	20	342	11
185	20	343	12
186	20	344	13
187	20	345	14
74	20	346	15
34	20	347	16
189	20	348	17
190	20	349	18
195	20	350	19
191	20	351	20
192	20	352	21
193	20	353	22
194	20	354	23
196	21	355	1
59	21	356	2
59	21	357	3
59	21	358	4
197	21	359	5
197	21	360	6
197	21	361	7
50	21	362	8
50	21	363	9
50	21	364	10
198	21	365	11
202	21	366	12
3	21	367	13
199	21	368	14
83	21	369	15
200	21	370	16
201	21	371	17
203	22	372	1
203	22	373	2
203	22	374	3
203	22	375	4
203	22	376	5
203	22	377	6
203	22	378	7
203	22	379	8
204	22	380	9
204	22	381	10
204	22	382	11
204	22	383	12
204	22	384	13
204	22	385	14
204	22	386	15
205	22	387	16
205	22	388	17
205	22	389	18
205	22	390	19
205	22	391	20
205	22	392	21
206	23	393	1
207	23	394	2
208	23	395	3
209	23	396	4
210	23	397	5
211	23	398	6
212	23	399	7
213	23	400	8
214	23	401	9
215	23	402	10
200	23	403	11
216	23	404	12
217	23	405	13
218	23	406	14
219	23	407	15
220	23	331	16
138	23	408	17
223	24	58	1
224	24	410	2
225	24	411	3
225	24	412	4
202	24	413	5
202	24	414	6
226	24	415	7
202	24	416	8
225	24	417	9
227	24	418	10
228	24	419	11
229	24	420	12
230	24	421	13
231	24	422	14
232	24	423	15
226	24	424	16
202	24	425	17
76	24	426	18
233	24	427	19
234	24	428	20
199	24	429	21
198	24	430	22
202	24	431	23
235	24	432	24
198	24	433	25
165	25	434	1
236	25	435	2
237	25	436	3
202	25	437	4
237	25	438	5
238	25	439	6
239	25	440	7
240	25	441	8
236	25	442	9
241	25	443	10
236	25	444	11
147	25	445	12
242	25	446	13
243	25	447	14
147	25	448	15
54	25	449	16
245	25	450	17
246	25	451	18
236	25	452	19
202	25	453	20
198	25	454	21
236	25	455	22
198	25	295	23
206	25	326	24
247	25	456	25
236	26	95	1
202	26	457	2
236	26	88	3
44	26	458	4
248	26	459	5
40	26	460	6
198	26	461	7
248	26	462	8
249	26	463	9
179	26	464	10
250	26	465	11
198	26	466	12
144	26	467	13
40	26	499	14
76	26	469	15
202	26	43	16
40	26	470	17
251	26	471	18
198	26	285	19
247	26	472	20
40	26	473	21
236	26	474	22
202	26	475	23
240	26	476	24
40	26	477	25
50	26	478	26
22	27	479	1
150	27	480	2
206	27	481	3
253	27	482	4
243	27	483	5
175	27	484	6
198	27	485	7
40	27	89	8
198	27	486	9
254	27	487	10
257	27	488	11
258	27	489	12
40	27	490	13
58	27	491	14
198	27	492	15
3	27	493	16
254	27	494	17
3	27	367	18
255	27	495	19
165	27	496	20
256	27	497	21
202	27	498	22
22	27	499	23
12	27	500	24
1	28	502	1
1	28	503	2
1	28	504	3
1	28	505	4
1	28	506	5
1	28	507	6
1	28	508	7
1	28	509	8
1	28	510	9
1	28	511	10
1	28	512	11
1	28	513	12
202	29	366	1
202	29	413	2
202	29	414	3
202	29	425	4
202	29	453	5
202	29	43	6
202	29	498	7
202	29	416	8
202	29	457	9
202	29	437	10
\.


--
-- Name: cd cd_pkey; Type: CONSTRAINT; Schema: cdbase2; Owner: root
--

ALTER TABLE ONLY cdbase2.cd
    ADD CONSTRAINT cd_pkey PRIMARY KEY (cid);


--
-- Name: company company_pkey; Type: CONSTRAINT; Schema: cdbase2; Owner: root
--

ALTER TABLE ONLY cdbase2.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (comid);


--
-- Name: performer performer_pkey; Type: CONSTRAINT; Schema: cdbase2; Owner: root
--

ALTER TABLE ONLY cdbase2.performer
    ADD CONSTRAINT performer_pkey PRIMARY KEY (pid);


--
-- Name: song song_pkey; Type: CONSTRAINT; Schema: cdbase2; Owner: root
--

ALTER TABLE ONLY cdbase2.song
    ADD CONSTRAINT song_pkey PRIMARY KEY (sid);


--
-- Name: track track_pkey; Type: CONSTRAINT; Schema: cdbase2; Owner: root
--

ALTER TABLE ONLY cdbase2.track
    ADD CONSTRAINT track_pkey PRIMARY KEY (cid, pos);


--
-- Name: cd cd_comid_fkey; Type: FK CONSTRAINT; Schema: cdbase2; Owner: root
--

ALTER TABLE ONLY cdbase2.cd
    ADD CONSTRAINT cd_comid_fkey FOREIGN KEY (comid) REFERENCES cdbase2.company(comid) ON UPDATE CASCADE;


--
-- Name: track track_cid_fkey; Type: FK CONSTRAINT; Schema: cdbase2; Owner: root
--

ALTER TABLE ONLY cdbase2.track
    ADD CONSTRAINT track_cid_fkey FOREIGN KEY (cid) REFERENCES cdbase2.cd(cid) ON UPDATE CASCADE;


--
-- Name: track track_pid_fkey; Type: FK CONSTRAINT; Schema: cdbase2; Owner: root
--

ALTER TABLE ONLY cdbase2.track
    ADD CONSTRAINT track_pid_fkey FOREIGN KEY (pid) REFERENCES cdbase2.performer(pid) ON UPDATE CASCADE;


--
-- Name: track track_sid_fkey; Type: FK CONSTRAINT; Schema: cdbase2; Owner: root
--

ALTER TABLE ONLY cdbase2.track
    ADD CONSTRAINT track_sid_fkey FOREIGN KEY (sid) REFERENCES cdbase2.song(sid) ON UPDATE CASCADE;


--
-- Name: SCHEMA cdbase2; Type: ACL; Schema: -; Owner: root
--

GRANT USAGE ON SCHEMA cdbase2 TO db;


--
-- Name: TABLE cd; Type: ACL; Schema: cdbase2; Owner: root
--

GRANT SELECT ON TABLE cdbase2.cd TO db;


--
-- Name: TABLE company; Type: ACL; Schema: cdbase2; Owner: root
--

GRANT SELECT ON TABLE cdbase2.company TO db;


--
-- Name: TABLE performer; Type: ACL; Schema: cdbase2; Owner: root
--

GRANT SELECT ON TABLE cdbase2.performer TO db;


--
-- Name: TABLE song; Type: ACL; Schema: cdbase2; Owner: root
--

GRANT SELECT ON TABLE cdbase2.song TO db;


--
-- Name: TABLE track; Type: ACL; Schema: cdbase2; Owner: root
--

GRANT SELECT ON TABLE cdbase2.track TO db;


--
-- PostgreSQL database dump complete
--

