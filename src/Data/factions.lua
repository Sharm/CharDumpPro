-- This is faction data from dbc
--
-- Rows separated by CRLF (\r\n)
-- Fields separeted by tab symbol (\t)

DB = DB or {}
DB.Factions = {}
DB.Factions.Fields = {
	{name = "id",		 type = "number"},	-- faction index
	{name = "repListId", type = "number"},	-- reputation list id		
	{name = "team",		 type = "number"},	-- team
	{name = "side",		 type = "number"},	-- side (1 - Alliance,  2 - Horde)
	{name = "name_enUS", type = "string"},	-- english title
	{name = "name_ruRU", type = "string"}	-- russian title
}
DB.Factions.KeyField = "id"
DB.Factions.Data = [[
1	-1	0	1	PLAYER, Human	ИГРОК: человек
2	-1	0	2	PLAYER, Orc	ИГРОК: орк
3	-1	0	1	PLAYER, Dwarf	ИГРОК: дворф
4	-1	0	1	PLAYER, Night Elf	ИГРОК: Ночной эльф
5	-1	0	2	PLAYER, Undead	ИГРОК: нежить
6	-1	0	2	PLAYER, Tauren 	ИГРОК: таурен
7	-1	0	0	Creature	Существо
8	-1	0	1	PLAYER, Gnome	ИГРОК: гном
9	-1	0	2	PLAYER, Troll	ИГРОК: тролль
14	-1	0	0	Monster	Монстр
15	-1	0	0	Defias Brotherhood	Братство Справедливости
16	-1	0	0	Gnoll - Riverpaw	Гнолл: Речная Лапа
17	-1	0	0	Gnoll - Redridge	Гнолл: Племя Красногорья
18	-1	0	0	Gnoll - Shadowhide	Гнолл: Темношкуры
19	-1	0	0	Murloc	Мурлок
20	-1	0	0	Undead, Scourge	Нежить, Плеть
21	1	169	0	Booty Bay	Пиратская бухта
22	-1	0	0	Beast - Spider	Животное: паук
23	-1	0	0	Beast - Boar	Животное: кабан
24	-1	0	0	Worgen	Ворген
25	-1	0	0	Kobold	Кобольд
26	-1	0	0	Troll, Bloodscalp	Тролль: Кровавый Скальп
27	-1	0	0	Troll, Skullsplitter	Тролль: Дробители Черепов
28	-1	0	0	Prey	Добыча
29	-1	0	0	Beast - Wolf	Животное: волк
30	-1	0	0	Defias Brotherhood Traitor	Предатель Братства Справедливости
31	-1	0	0	Friendly	Дружественный
32	-1	0	0	Trogg	Трогг
33	-1	0	0	Troll, Frostmane	Тролль: Мерзлогривы
34	-1	0	0	Orc, Blackrock	Орк: Черная гора
35	-1	0	0	Villian	Злодей
36	-1	0	0	Victim	Жертва
37	-1	0	0	Beast - Bear	Животное: медведь
38	-1	0	0	Ogre	Огр
39	-1	0	0	Kurzen's Mercenaries	Наемники Курцена
40	-1	0	0	Escortee	Сопровождаемый
41	-1	0	0	Venture Company	Торговая компания
42	-1	0	0	Beast - Raptor	Животное: ящер
43	-1	0	0	Basilisk	Василиск
44	-1	0	0	Dragonflight, Green	Зеленые драконы
45	-1	0	0	Lost Ones	Заблудшие
46	29	0	0	 Blacksmithing - Armorsmithing	Кузнечное дело: ковка доспехов
47	20	469	1	Ironforge	Стальгорн
48	-1	0	0	Dark Iron Dwarves	Дворфы Черного Железа
49	-1	0	1	Human, Night Watch	Человек: Ночной Дозор
50	-1	0	0	Dragonflight, Red	Красные драконы
51	-1	0	0	Gnoll - Mosshide	Гнолл: Мохошкур
52	-1	0	0	Orc, Dragonmaw	Орк: Драконья Пасть
53	-1	0	0	Gnome - Leper	Гном: зараженный
54	18	469	1	Gnomeregan Exiles	Изгнанники Гномрегана
55	-1	0	0	Leopard	Леопард
56	-1	0	0	Scarlet Crusade	Алый орден
57	-1	0	0	Gnoll - Rothide	Гнолл: Гнилошкуры
58	-1	0	0	Beast - Gorilla	Животное: горилла
59	4	0	0	Thorium Brotherhood	Братство Тория
60	-1	0	0	Naga	Нага
61	-1	0	1	Dalaran	Даларан
62	-1	0	0	Forlorn Spirit	Неприкаянный дух
63	-1	0	0	Darkhowl	Мрачный Вой
64	-1	0	0	Grell	Грелль
65	-1	0	0	Furbolg	Фурболг
66	-1	0	2	Horde Generic	Орда: стандартный
67	12	0	2	Horde	Орда
68	17	67	2	Undercity	Подгород
69	21	469	1	Darnassus	Дарнасс
70	6	0	0	Syndicate	Синдикат
71	-1	0	1	Hillsbrad Militia	Дружина Хилсбрада
72	19	469	1	Stormwind	Штормград
73	-1	0	0	Demon	Демон
74	-1	0	0	Elemental	Элементаль
75	-1	0	0	Spirit	Дух
76	14	67	2	Orgrimmar	Оргриммар
77	-1	0	0	Treasure	Сокровище
78	-1	0	0	Gnoll - Mudsnout	Гнолл: Грязнорылы
79	-1	0	0	HIllsbrad, Southshore Mayor	Хиллсбрад, мэр Южнобережья
80	-1	0	0	Dragonflight, Black	Черные драконы
81	16	67	2	Thunder Bluff	Громовой Утес
82	-1	0	0	Troll, Witherbark	Тролль: Сухокожие
83	23	0	0	 Leatherworking - Elemental	Кожевничество: сила стихий
84	-1	0	0	Quilboar, Razormane	Свинобраз: Иглогривые
85	-1	0	0	Quilboar, Bristleback	Свинобраз: Дыбогривы
86	22	0	0	 Leatherworking - Dragonscale	Кожевничество: чешуя драконов
87	0	0	0	Bloodsail Buccaneers	Пираты Кровавого Паруса
88	-1	0	0	Blackfathom	Непроглядная пучина
89	-1	0	0	Makrura	Макрура
90	-1	0	0	Centaur, Kolkar	Кентавр: Колкар
91	-1	0	0	Centaur, Galak	Кентавр: Галак
92	2	0	0	Gelkis Clan Centaur	Кентавры из племени Гелкис
93	3	0	0	Magram Clan Centaur	Кентавры племени Маграм
94	-1	0	0	Maraudine	Мародин
108	-1	0	0	Theramore	Терамор
109	-1	0	0	Quilboar, Razorfen	Свинобраз: Иглошкуры
110	-1	0	0	Quilboar, Razormane 2	Свинобраз: Иглогривые
111	-1	0	0	Quilboar, Deathshead	Свинобраз: Мертвая Голова
128	-1	0	0	Enemy	Противник
148	-1	0	0	Ambient	Фауна
168	-1	0	0	Nethergarde Caravan	Караван Стражей Пустоты
169	10	0	0	Steamwheedle Cartel	Картель Хитрая Шестеренка
189	-1	0	1	Alliance Generic	Альянс: стандартный
209	-1	0	0	Nethergarde	Крепость Стражей Пустоты
229	-1	0	0	Wailing Caverns	Пещеры Стенаний
249	-1	0	0	Silithid	Силитиды
269	-1	0	1	Silvermoon Remnant	Дети Луносвета
270	51	0	0	Zandalar Tribe	Племя Зандалар
289	30	0	0	 Blacksmithing - Weaponsmithing	Кузнечное дело: ковка оружия
309	-1	0	0	Scorpid	Скорпид
310	-1	0	0	Beast - Bat	Животное: летучая мышь
311	-1	0	0	Titan	Титан
329	-1	0	0	Taskmaster Fizzule	Надсмотрщик Физзул
349	5	0	0	Ravenholdt	Черный Ворон
369	7	169	0	Gadgetzan	Прибамбасск
389	-1	0	0	Gnomeregan Bug	Гномреганский жук
409	-1	0	0	Harpy	Гарпия
429	-1	0	0	Burning Blade	Пылающий Клинок
449	-1	0	0	Shadowsilk Poacher	Браконьер тенешелка
450	-1	0	0	Searing Spider	Лавовый паук
469	11	0	1	Alliance	Альянс
470	9	169	0	Ratchet	Кабестан
471	8	0	0	Wildhammer Clan	Неистовый Молот
489	-1	0	0	Goblin, Dark Iron Bar Patron	Гоблин: завсегдатай бара Черного Железа
509	53	891	1	The League of Arathor	Лига Аратора
510	52	892	2	The Defilers	Осквернители
511	-1	0	0	Giant	Великан
529	13	0	0	Argent Dawn	Серебряный Рассвет
530	15	67	2	Darkspear Trolls	Тролли Черного Копья
531	-1	0	0	Dragonflight, Bronze	Бронзовые драконы
532	-1	0	0	Dragonflight, Blue	Синие драконы
549	24	0	0	 Leatherworking - Tribal	Кожевничество: традиции предков
550	26	0	0	 Engineering - Goblin	Инженерное дело: школа гоблинов
551	25	0	0	 Engineering - Gnome	Инженерное дело: школа гномов
569	33	0	0	 Blacksmithing - Hammersmithing	Кузнечное дело: ковка молотов
570	31	0	0	 Blacksmithing - Axesmithing	Кузнечное дело: ковка топоров
571	32	0	0	 Blacksmithing - Swordsmithing	Кузнечное дело: ковка мечей
572	-1	0	0	Troll, Vilebranch	Тролль: Порочная Ветвь
573	-1	0	0	Southsea Freebooters	Флибустьеры Южных морей
574	34	0	0	Caer Darrow	Каэр Дарроу
575	-1	0	0	Furbolg, Uncorrupted	Фурболг, Неиспорченный
576	35	0	0	Timbermaw Hold	Древобрюхи
577	28	169	0	Everlook	Круговзор
589	27	0	1	Wintersaber Trainers	Укротители ледопардов
609	36	0	0	Cenarion Circle	Служители Ценариона
629	-1	0	0	Shatterspear Trolls	Тролли из племени Пронзающего Копья
630	-1	0	0	Ravasaur Trainers	Дрессировщики равазавров
649	-1	0	0	Majordomo Executus	Мажордом Экзекутус
669	-1	0	0	Beast - Carrion Bird	Животное: падальщик
670	-1	0	0	Beast - Cat	Животное: кошка
671	-1	0	0	Beast - Crab	Животное: краб
672	-1	0	0	Beast - Crocilisk	Животное: кроколиск
673	-1	0	0	Beast - Hyena	Животное: гиена
674	-1	0	0	Beast - Owl	Животное: сова
675	-1	0	0	Beast - Scorpid	Животное: скорпид
676	-1	0	0	Beast - Tallstrider	Животное: долгоног
677	-1	0	0	Beast - Turtle	Животное: черепаха
678	-1	0	0	Beast - Wind Serpent	Животное: крылатый змей
679	-1	0	0	Training Dummy	Чучело для тренировок
689	-1	0	0	Dragonflight, Black - Bait	Черные драконы: наживка
709	-1	0	0	Battleground Neutral	Поле боя: нейтральные
729	41	892	2	Frostwolf Clan	Клан Северного Волка
730	40	891	1	Stormpike Guard	Стража Грозовой Вершины
749	42	0	0	Hydraxian Waterlords	Гидраксианские Повелители Вод
750	-1	0	0	Sulfuron Firelords	Сульфуронские Повелители Огня
769	-1	0	0	Gizlock's Dummy	Болванчик Гизлока
770	-1	0	0	Gizlock's Charm	Оберег Гизлока
771	-1	0	0	Gizlock	Гизлок
789	-1	0	0	Moro'gai	Моро'гай
790	-1	0	0	Spirit Guide - Alliance	Хранитель душ: Альянс
809	44	0	0	Shen'dralar	Шен'дралар
829	-1	0	0	Ogre (Captain Kromcrush)	Огр: Капитан Давигром
849	-1	0	0	Spirit Guide - Horde	Хранитель душ: Орда
869	-1	0	0	Jaedenar	Джеденар
889	46	892	2	Warsong Outriders	Всадники Песни Войны
890	45	891	1	Silverwing Sentinels	Среброкрылые Часовые
891	47	0	0	Alliance Forces	Силы Альянса
892	48	0	0	Horde Forces	Силы Орды
893	-1	0	0	Revantusk Trolls	Тролли Сломанного Клыка
909	50	0	0	Darkmoon Faire	Ярмарка Новолуния
910	54	0	0	Brood of Nozdormu	Род Ноздорму
911	55	67	2	Silvermoon City	Луносвет
912	-1	0	0	Might of Kalimdor	Армия Калимдора
914	-1	0	2	PLAYER, Blood Elf	ИГРОК: эльф крови
915	-1	0	0	Armies of C'Thun	Армии К'Туна
916	-1	0	0	Silithid Attackers	Силитиды: захватчики
917	-1	0	0	The Ironforge Brigade	Дружина Стальгорна
918	-1	0	0	RC Enemies	ДУ противники
919	-1	0	0	RC Objects	ДУ объекты
920	-1	0	0	Red	Красные
921	-1	0	0	Blue	Синие
922	56	0	2	Tranquillien	Транквиллион
923	-1	0	2	Farstriders	Странники
924	-1	0	0	DEPRECATED	ИСКЛЮЧЕНО
925	-1	0	0	Sunstriders	Солнечные скитальцы
926	-1	0	0	Magister's Guild	Гильдия Магистра
927	-1	0	1	PLAYER, Draenei	ИГРОК: дреней
928	-1	0	0	Scourge Invaders	Захватчики Плети
929	-1	469	0	Bloodmaul Clan	Клан Кровавого Молота
930	49	469	1	Exodar	Экзодар
931	-1	0	0	Test Faction (not a real faction)	Тестовая фракция (несуществующая)
932	58	936	0	The Aldor	Алдоры
933	60	980	0	The Consortium	Консорциум
934	62	936	0	The Scryers	Провидцы
935	39	936	0	The Sha'tar	Ша'тар
936	59	0	0	Shattrath City	Город Шаттрат
937	-1	0	0	Troll, Forest	Тролль: Лесной
938	-1	0	0	The Omenai	Оменай
939	-1	0	0	DEPRECATED	ИСКЛЮЧЕНО
940	-1	0	1	The Sons of Lothar	Сыны Лотара
941	61	980	2	The Mag'har	Маг'хары
942	64	980	0	Cenarion Expedition	Экспедиция Ценариона
943	-1	0	0	Fel Orc	Орк Скверны
944	-1	0	0	Fel Orc Ghost	Призрак орка Скверны
945	-1	0	0	Sons of Lothar Ghosts	Призраки Сыновей Лотара
946	38	980	1	Honor Hold	Оплот Чести
947	37	980	2	Thrallmar	Траллмар
948	-1	0	0	Test Faction 2	Тестовая фракция 2
949	-1	0	0	Test Faction 1	Тестовая фракция 1
950	-1	0	0	ToWoW - Flag	ToWoW: флаг
951	-1	0	0	ToWoW - Flag Trigger Alliance (DND)	ToWoW: инициатор флага Альянса (DND)
952	-1	0	0	Test Faction 3	Тестовая фракция 3
953	-1	0	0	Test Faction 4	Тестовая фракция 4
954	-1	0	0	ToWoW - Flag Trigger Horde (DND)	ToWoW: инициатор флага Орды (DND)
955	-1	0	0	Broken	Сломленные
956	-1	0	0	Ethereum	Братство Эфириум
957	-1	0	0	Earth Elemental	Элементаль земли
958	-1	0	0	Fighting Robots	Боевые роботы
959	-1	0	0	Actor Good	Добрый персонаж
960	-1	0	0	Actor Evil	Злой персонаж
961	-1	0	0	Stillpine Furbolg	Фурболг: племя Тихвой
962	-1	0	0	Crazed Owlkin	Безумный совун
963	-1	0	0	Chess Alliance	Шахматы: Альянс
964	-1	0	0	Chess Horde	Шахматы: Орда
965	-1	0	0	Monster Spar	Монстр: партнер по учебному бою
966	-1	0	0	Monster Spar Buddy	Монстр: партнер по учебному бою
967	63	0	0	The Violet Eye	Аметистовое Око
968	-1	0	0	Sunhawks	Солнечные Ястребы
969	-1	0	0	Hand of Argus	Длань Аргуса
970	65	980	0	Sporeggar	Спореггар
971	-1	0	0	Fungal Giant	Грибной великан
972	-1	0	0	Spore Bat	Спороскат
973	-1	0	0	Monster, Predator	Монстр: хищник
974	-1	0	0	Monster, Prey	Монстр: добыча
975	-1	0	0	Void Anomaly	Аномалия Бездны
976	-1	0	0	Hyjal Defenders	Защитники горы Хиджал
977	-1	0	0	Hyjal Invaders	Захватчики горы Хиджал
978	66	980	1	Kurenai	Куренай
979	-1	0	0	Earthen Ring	Служители Земли
980	43	0	0	Outland	Запределье
981	-1	0	0	Arakkoa	Араккоа
982	-1	0	0	Zangarmarsh Banner (Alliance)	Знамя Зангартопи: Альянс
983	-1	0	0	Zangarmarsh Banner (Horde)	Знамя Зангартопи: Орда
984	-1	0	0	Zangarmarsh Banner (Neutral)	Знамя Зангартопи: нейтральное
985	-1	0	0	Caverns of Time - Thrall	Пещеры Времени: Тралл
986	-1	0	0	Caverns of Time - Durnholde	Пещеры Времени: Дарнхольд
987	-1	0	0	Caverns of Time - Southshore Guards	Пещеры Времени: Стражи Южнобережья
988	-1	0	0	Shadow Council Covert	Прибежище Совета Теней
989	67	0	0	Keepers of Time	Хранители Времени
990	57	0	0	The Scale of the Sands	Песчаная Чешуя
991	-1	0	0	Dark Portal Defender, Alliance	Защитник Темного портала: Альянс
992	-1	0	0	Dark Portal Defender, Horde	Защитник Темного портала: Орда
993	-1	0	0	Dark Portal Attacker, Legion	Захватчик Темного портала: Легион
994	-1	0	0	Inciter Trigger	Инициатор
995	-1	0	0	Inciter Trigger 2	Инициатор 2
996	-1	0	0	Inciter Trigger 3	Инициатор 3
997	-1	0	0	Inciter Trigger 4	Инициатор 4
998	-1	0	0	Inciter Trigger 5	Инициатор 5
999	-1	0	0	Mana Creature	Существо с маной
1000	-1	0	0	Khadgar's Servant	Слуга Кадгара
1001	-1	0	0	Bladespire Clan	Клан Камнерогов
1002	-1	0	0	Ethereum Sparbuddy	Братство Эфириум: манекен
1003	-1	0	0	Protectorate	Протекторат
1004	-1	0	0	Arcane Annihilator (DNR)	Волшебный уничтожитель
1005	68	0	0	Friendly, Hidden	Дружественный, скрытый
1006	-1	0	0	Kirin'Var - Dathric	Кирин'Вар: Датрик
1007	-1	0	0	Kirin'Var - Belmara	Кирин'Вар: Белмара
1008	-1	0	0	Kirin'Var - Luminrath	Кирин'Вар: Люминрат
1009	-1	0	0	Kirin'Var - Cohlien	Кирин'Вар: Колиен
1010	-1	0	0	Servant of Illidan	Прислужник Иллидана
1011	69	936	0	Lower City	Нижний Город
1012	70	980	0	Ashtongue Deathsworn	Пеплоусты-служители
1013	-1	0	0	Spirits of Shadowmoon 1	Духи Призрачной Луны 1
1014	-1	0	0	Spirits of Shadowmoon 2	Духи Призрачной Луны 2
1015	71	980	0	Netherwing	Крылья Пустоверти
1016	-1	0	0	Wyrmcult	Культ Змея
1017	-1	0	0	Treant	Древень
1018	-1	0	0	Leotheras Demon I	Демон Леотераса I
1019	-1	0	0	Leotheras Demon II	Демон Леотераса II
1020	-1	0	0	Leotheras Demon III	Демон Леотераса III
1021	-1	0	0	Leotheras Demon IV	Демон Леотераса IV
1022	-1	0	0	Leotheras Demon V	Демон Леотераса V
1023	-1	0	0	Azaloth	Азалот
1024	-1	0	0	Rock Flayer	Камнедер
1025	-1	0	0	Flayer Hunter	Охотник на свежевальщиков
1026	-1	0	0	Shadowmoon Shade	Тень Призрачной Луны
1027	-1	0	0	Legion Communicator	Переговорное устройство Легиона
1028	-1	0	0	Ravenswood Ancients	Древние из Леса Воронов
1029	-1	0	0	Chess, Friendly to All Chess	Шахматы: дружественный ко всем
1030	-1	0	0	Black Temple Gates - Illidari	Врата Черного храма: Иллидари
1031	72	936	0	Sha'tari Skyguard	Стражи Небес Ша'тар
1032	-1	0	0	Area 52	Зона 52
1033	-1	0	0	Maiev	Майев
1034	-1	0	0	Skettis Shadowy Arakkoa	Призрачный Араккоа Скеттиса
1035	-1	0	0	Skettis Arakkoa	Араккоа Скеттиса
1036	-1	0	0	Dragonmaw Enemy	Драконья Пасть: противник
1037	-1	0	0	REUSE	REUSE
1038	73	980	0	Ogri'la	Огри'ла
1039	-1	0	0	Ravager	Опустошитель
1040	-1	0	0	REUSE	REUSE
1041	-1	0	0	Frenzy	Бешенство
1042	-1	0	0	Skyguard Enemy	Враг Стражи Небес
1043	-1	0	0	Skunk, Petunia	Скунс: Петунья
1044	-1	0	0	Theramore Deserter	Тераморский дезертир
1049	-1	0	0	Troll, Amani	Тролль: Амани
1059	-1	0	0	CTF - Flags	Захват флага: флаги
1069	-1	0	0	Ram Racing Powerup DND	Скачки на баранах: бонус DND
1070	-1	0	0	Ram Racing Trap DND	Скачки на баранах: ловушка DND
1071	-1	0	0	Craig's Squirrels	Белочки Крейга
1074	-1	0	0	Holiday - Water Barrel	Праздник: бочка с водой
1075	-1	0	0	Holiday - Generic	Праздник: стандартный
1077	80	936	0	Shattered Sun Offensive	Армия Расколотого Солнца
1078	-1	0	0	Fighting Vanity Pet	Страж-спутник
1080	-1	0	0	Monster, Force Reaction	
1081	-1	0	0	Object, Force Reaction	
1087	-1	0	0	Holiday Monster	
]]