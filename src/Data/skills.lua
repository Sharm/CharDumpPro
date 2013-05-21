-- This is skills data from dbc
--
-- Rows separated by CRLF (\r\n)
-- Fields separeted by tab symbol (\t)

DB = DB or {}
DB.Skills = {}
DB.Skills.Fields = {
	{name = "id",		  type = "number"},  -- skill index
	{name = "categoryId", type = "number"},  -- category id (6 - weapons/defense, 11 - professions, etc)	
	{name = "name_enUS",  type = "string"},  -- english title
	{name = "name_ruRU",  type = "string"}   -- russian title
}
DB.Skills.KeyField = "id"
DB.Skills.Data = [[
6	7	Frost	Лед
8	7	Fire	Огонь
26	7	Arms	Оружие
38	7	Combat	Бой
39	7	Subtlety	Скрытность
40	7	Poisons	Яды
43	6	Swords	Мечи
44	6	Axes	Топоры
45	6	Bows	Луки
46	6	Guns	Огнестрельное оружие
50	7	Beast Mastery	Чувство зверя
51	7	Survival	Выживание
54	6	Maces	Дробящее оружие
55	6	Two-Handed Swords	Двуручные мечи
56	7	Holy	Свет
78	7	Shadow Magic	Темная магия
95	6	Defense	Защита
98	10	Language: Common	Язык: всеобщий
101	9	Dwarven Racial	Расовый навык дворфов
109	10	Language: Orcish	Язык: орочий
111	10	Language: Dwarven	Язык: дворфийский
113	10	Language: Darnassian	Язык: дарнасский
115	10	Language: Taurahe	Язык: таурахэ
118	6	Dual Wield	Бой двумя руками
124	9	Tauren Racial	Расовый навык тауренов
125	9	Orc Racial	Расовый навык орков
126	9	Night Elf Racial	Расовый навык ночных эльфов
129	9	First Aid	Первая помощь
134	7	Feral Combat	Сила зверя
136	6	Staves	Посохи
137	10	Language: Thalassian	Язык: талассийский
138	10	Language: Draconic	Язык: драконий
139	10	Language: Demon Tongue	Язык: наречие демонов
140	10	Language: Titan	Язык: наречие титанов
141	10	Language: Old Tongue	Язык: древний
142	9	Survival	Выживание
148	9	Horse Riding	Езда на лошадях
149	9	Wolf Riding	Езда на волках
150	9	Tiger Riding	Езда на тиграх
152	9	Ram Riding	Езда на баранах
155	9	Swimming	Плавание
160	6	Two-Handed Maces	Двуручное дробящее
162	6	Unarmed	Рукопашный бой
163	7	Marksmanship	Стрельба
164	11	Blacksmithing	Кузнечное дело
165	11	Leatherworking	Кожевенное дело
171	11	Alchemy	Алхимия
172	6	Two-Handed Axes	Двуручные топоры
173	6	Daggers	Кинжалы
176	6	Thrown	Метательное оружие
182	11	Herbalism	Травничество
183	12	GENERIC (DND)	GENERIC (DND)
184	7	Retribution	Возмездие
185	9	Cooking	Кулинарное искусство
186	11	Mining	Горное дело
188	7	Pet - Imp	Питомец: бес
189	7	Pet - Felhunter	Прислужник: охотник Скверны
197	11	Tailoring	Портняжное дело
202	11	Engineering	Инженерное дело
203	7	Pet - Spider	Питомец: паук
204	7	Pet - Voidwalker	Прислужник: демон Пустоты
205	7	Pet - Succubus	Прислужник: суккуб
206	7	Pet - Infernal	Прислужник: огненный голем
207	7	Pet - Doomguard	Прислужник: Стражник Ужаса
208	7	Pet - Wolf	Питомец: волк
209	7	Pet - Cat	Питомец: кошка
210	7	Pet - Bear	Питомец: медведь
211	7	Pet - Boar	Питомец: кабан
212	7	Pet - Crocilisk	Питомец: кроколиск
213	7	Pet - Carrion Bird	Питомец: падальщик
214	7	Pet - Crab	Питомец: краб
215	7	Pet - Gorilla	Питомец: горилла
217	7	Pet - Raptor	Питомец: ящер
218	7	Pet - Tallstrider	Питомец: долгоног
220	9	Racial - Undead	Расовый навык нежити
226	6	Crossbows	Арбалеты
228	6	Wands	Жезлы
229	6	Polearms	Древковое оружие
236	7	Pet - Scorpid	Питомец: скорпид
237	7	Arcane	Тайная магия
251	7	Pet - Turtle	Питомец: черепаха
253	7	Assassination	Убийство
256	7	Fury	Неистовство
257	7	Protection	Защита
261	7	Beast Training	Воспитание питомца
267	7	Protection	Защита
270	7	Pet - Generic	Питомец: любой
293	8	Plate Mail	Латы
313	10	Language: Gnomish	Язык: гномий
315	10	Language: Troll	Язык: наречие троллей
333	11	Enchanting	Чародейство
354	7	Demonology	Демонология
355	7	Affliction	Колдовство
356	9	Fishing	Рыбная ловля
373	7	Enhancement	Совершенствование
374	7	Restoration	Исцеление
375	7	Elemental Combat	Укрощение стихии
393	11	Skinning	Свежевание
413	8	Mail	Кольчужные доспехи
414	8	Leather	Кожаные доспехи
415	8	Cloth	Тканевые доспехи
433	8	Shield	Щит
473	6	Fist Weapons	Кистевое оружие
533	9	Raptor Riding	Езда на рапторах
553	9	Mechanostrider Piloting	Вождение механострауса
554	9	Undead Horsemanship	Верховая езда нежити
573	7	Restoration	Исцеление
574	7	Balance	Баланс
593	7	Destruction	Разрушение
594	7	Holy	Свет
613	7	Discipline	Послушание
633	7	Lockpicking	Взлом
653	7	Pet - Bat	Питомец: летучая мышь
654	7	Pet - Hyena	Питомец: гиена
655	7	Pet - Owl	Питомец: сова
656	7	Pet - Wind Serpent	Питомец: крылатый змей
673	10	Language: Gutterspeak	Язык: наречие нежити
713	9	Kodo Riding	Езда на кодо
733	9	Racial - Troll	Расовый навык троллей
753	9	Racial - Gnome	Расовый навык гномов
754	9	Racial - Human	Расовый: люди
755	11	Jewelcrafting	Ювелирное дело
756	9	Blood Elf Racial	Расовый навык эльфов крови
758	-1	Pet - Event - Remote Control	Питомец - управление
759	10	Language: Draenei	Язык: дренейский
760	9	Draenei Racial	Расовый навык дренея
761	7	Pet - Felguard	Прислужник: страж Скверны
762	9	Riding	Верховая езда
763	7	Pet - Dragonhawk	Питомец: дракондор
764	7	Pet - Nether Ray	Питомец: скат Пустоты
765	7	Pet - Sporebat	Питомец: Спороскат
766	7	Pet - Warp Stalker	Питомец: астральная игуана
767	-1	Pet - Ravager	Питомец: опустошитель
768	7	Pet - Serpent	Питомец: змей
769	7	Internal	Внутренний
]]