﻿////////////////////////////////////////////////////////////////////////////////
// ПОДГОТОВКА ДАННЫХ ПОРТАЛА

Функция ПолучитьОбщуюЧастьСтраницы(Параметры)
	
	АдресаКартинок		= ?(Параметры.Свойство("Картинки"), Параметры.Картинки, Новый Структура);
	ТекстСкрипты		= ?(Параметры.Свойство("Скрипты"), Параметры.Скрипты, "");
	Заголовок			= ?(Параметры.Свойство("Заголовок"), Параметры.Заголовок, "");
	
	ТаблицаСтилей	= БазаЗнанийCSSКлиентСервер.ПолучитьТаблицуСтилей();
	
	ТекстСтраницы = 
	"<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">
	|<html xmlns=""http://www.w3.org/1999/xhtml"">
	|	<head>
	|		<title>" + Заголовок + "</title>
	|		" + ТекстСкрипты + "
	|		" + ТаблицаСтилей + "
	|	</head>
	|	<body>
	|		<div id='content' class='content_main'>
	|			[[ОсновнойКонтент]]
	|		</div>
	|		<div id='footer'>
	//|			<div align='center' style='font-size:9px;'>
	//|				Copyright © 2005-2014 <a href='http://www.progtb.ru/'>ООО ""ПрогТехБизнес""</a>.
	//|				All rights reserved.
	//|				Phone: +7(347)289-91-60. E-mail: <a href='mailto:company@progtb.ru'>Написать нам</a>
	//|			</div>
	|		</div>	
	|	</body>
	|</html>";
	
	Возврат ТекстСтраницы;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБЩАЯ ФУНКЦИОНАЛЬНОСТЬ

Функция ВыделитьЭлементHTMLПоТегу(знач ТекстHTML, знач НачПозиция, знач ТегHTML) Экспорт
	
	ТегНачала		= "<" + НРег(ТегHTML);
	ТекОкончания	= "</" + НРег(ТегHTML) + ">";
	ДлинаТегНач		= СтрДлина(ТегНачала);
	ДлинаТегКон		= СтрДлина(ТекОкончания);
	
	ПозицияНачТекста = -1;
	ПозицияКонТекста = -1;
	
	// Вычисляем нач. текста
	Для Индекс = 1 По НачПозиция Цикл
		ТекПозиция	= НачПозиция - Индекс;
		ЗначениеСтр	= Сред(ТекстHTML, ТекПозиция, ДлинаТегНач);
		
		Если НРег(ЗначениеСтр) = ТегНачала Тогда
			ПозицияНачТекста = ТекПозиция;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// Вычисляем кон. текста\
	ВложенныеУровни = 0;
	Если ПозицияНачТекста >= 0 Тогда
		ДлинаТекста = СтрДлина(ТекстHTML);
		Для Индекс = НачПозиция По ДлинаТекста Цикл
			ТегНач = Сред(ТекстHTML, Индекс, ДлинаТегНач);
			ТегКон = Сред(ТекстHTML, Индекс, ДлинаТегКон);
			
			Если НРег(ТегНач) = ТегНачала Тогда
				ВложенныеУровни = ВложенныеУровни + 1;
			ИначеЕсли НРег(ТегКон) = ТекОкончания Тогда
				Если ВложенныеУровни = 0 Тогда
					ПозицияКонТекста = Индекс;
					Прервать;
				ИначеЕсли ВложенныеУровни > 0 Тогда
					ВложенныеУровни = ВложенныеУровни - 1;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Вырезаем строку
	Если ПозицияНачТекста >= 0 И ПозицияКонТекста > 0 И ПозицияКонТекста > ПозицияНачТекста Тогда
		ИтоговыйРезультат = Сред(ТекстHTML, ПозицияНачТекста, ПозицияКонТекста - ПозицияНачТекста + ДлинаТегКон);
	Иначе 
		ИтоговыйРезультат = "";
	КонецЕсли;
	
	Возврат ИтоговыйРезультат;
	
КонецФункции

Процедура ПроверитьСвойствоКоллекции(Коллекция, Ключ, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	ТипКоллекции = Тип(Коллекция);
	Если ТипКоллекции = Тип("Структура") Тогда
		Если НЕ Коллекция.Свойство(Ключ) Тогда
			Коллекция.Вставить(Ключ, ЗначениеПоУмолчанию);
		КонецЕсли;
	ИначеЕсли ТипКоллекции = Тип("Соответствие") Тогда
		ЗначениеКоллекции = Коллекция.Получить(Ключ);
		Если ЗначениеКоллекции = Неопределено И ЗначениеПоУмолчанию <> Неопределено Тогда
			Коллекция.Вставить(Ключ, ЗначениеПоУмолчанию);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВырезатьТекстТелаДокумента(Текст) Экспорт
	
	НРегТекст = НРег(Текст);
	
	НачалоОпределения	= Найти(НРегТекст, "<body>");
	КонецОпределения	= Найти(НРегТекст, "</body>");
	
	Текст = Сред(Текст, НачалоОпределения + 6, КонецОпределения - НачалоОпределения - 6);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА КАРТИНОК ДЛЯ ОТОБРАЖЕНИЯ

Процедура ОбработатьДополнительныеКартинки(ДопКартинки) Экспорт
	
	Если НЕ ТипЗнч(ДопКартинки) = Тип("Соответствие") Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент ИЛИ Сервер ИЛИ ВнешнееСоединение Тогда
		ОбработатьДопКартинкиИнтернет(ДопКартинки);
	#Иначе
		ОбработатьДопКартинкиЛокально(ДопКартинки);
	#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВЕРСТКА СТРАНИЦ ДЛЯ САЙТА

Функция ПолучитьОсновуСтраницы(ОбщиеКартинки, ТекстСкрипты, Заголовок = "") Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Картинки"	, ОбщиеКартинки);
	Параметры.Вставить("Скрипты"	, ТекстСкрипты);
	Параметры.Вставить("Заголовок"	, Заголовок);
	
	Возврат ПолучитьОбщуюЧастьСтраницы(Параметры);
	
КонецФункции

Функция ПолучитьОбщиеФайлы() Экспорт
	
	#Если ВебКлиент ИЛИ Сервер ИЛИ ВнешнееСоединение Тогда
		ВидХранения = "web";
		Каталог		= БазаЗнанийКлиентСерверПовтИсп.ПолучитьЗначениеОбщейНастройки("WebКаталог");
		Каталог		= Каталог + ?(Прав(Каталог, 1) + "/", "", "/");
	#Иначе
		ВидХранения = "local";
		Каталог		= БазаЗнанийКлиентСерверПовтИсп.ПолучитьЗначениеОбщейНастройки("ЛокальныйКаталог");
		Если Лев(Каталог, 2) = "\\" Тогда
			ВидХранения = "network";
		ИначеЕсли ПустаяСтрока(Каталог) Тогда
			Каталог = КаталогВременныхФайлов() + "kb_1c_ptb";
		КонецЕсли;
		Каталог		= Каталог + ?(Прав(Каталог, 1) = "\", "", "\");
	#КонецЕсли
	
	СтруктураКартинки	= ПолучитьОбщиеКартинки(ВидХранения, Каталог);
	СтруктураСкрипты	= ПолучитьОбщиеСкрипты(ВидХранения, Каталог);
	ТекстСкрипты		= "";
	
	Если ВидХранения = "web" Тогда
		ОбработатьОбщиеКартинкиИнтернет(СтруктураКартинки);
		ОбработатьОбщиеСкриптыИнтернет(СтруктураСкрипты, ТекстСкрипты);
	Иначе 
		ОбработатьОбщиеКартинкиЛокально(СтруктураКартинки);
		ОбработатьОбщиеСкриптыЛокально(СтруктураСкрипты, ТекстСкрипты);
	КонецЕсли;
	
	Возврат Новый Структура("Картинки, Скрипты", СтруктураКартинки, ТекстСкрипты);
		
КонецФункции

Функция ПолучитьПараметрыВыводаСтраницыПоВиду(ВидСтраницы) Экспорт
	
	ПараметрыВывода = Новый Структура("Информация, Заголовок, Кнопки, Порядок", "", "", "");
	
	Если ВидСтраницы = "featured_articles" Тогда
		ПараметрыВывода.Информация	= "Просмотрена";
		ПараметрыВывода.Заголовок	= "Рекомендуемые статьи";
		ПараметрыВывода.Порядок		= "СредняяОценка УБЫВ, Просмотры УБЫВ, Ссылка ВОЗР";
	ИначеЕсли ВидСтраницы = "recently_added" Тогда
		ПараметрыВывода.Информация	= "Опубликована";
		ПараметрыВывода.Заголовок	= "Недавно добавленные статьи";
		ПараметрыВывода.Порядок		= "Создана УБЫВ, Ссылка ВОЗР";
	ИначеЕсли ВидСтраницы = "most_popular" Тогда
		ПараметрыВывода.Информация	= "Просмотрена";
		ПараметрыВывода.Заголовок	= "Самые популярные статьи";
		ПараметрыВывода.Порядок		= "Просмотры УБЫВ, Ссылка ВОЗР";
	ИначеЕсли ВидСтраницы = "top_rated" Тогда
		ПараметрыВывода.Информация	= "Оценена";
		ПараметрыВывода.Заголовок	= "Наиболее рейтинговые статьи";
		ПараметрыВывода.Порядок		= "СредняяОценка УБЫВ, Ссылка ВОЗР";
	ИначеЕсли ВидСтраницы = "category_articles" Тогда
		ПараметрыВывода.Информация	= "КраткоеОписание";
		ПараметрыВывода.Заголовок	= "Статьи по категории";
		ПараметрыВывода.Кнопки		= "Добавить, ПереключениеСтраниц";
		ПараметрыВывода.Порядок		= "РеквизитДопУпорядочивания ВОЗР";
	КонецЕсли;

	Возврат ПараметрыВывода;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ МЕТОДЫ

// Скрипты

Функция ПолучитьОбщиеСкрипты(ВидХранения, Каталог)
	
	КаталогПоУмолчанию = СокрЛП(Каталог);
	
	СтруктураСкриптов = Новый Структура;
	СтруктураСкриптов.Вставить("jquery", 
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию + "jquery_1_11_0_min.js", "jquery_1_11_0_min", Ложь));
	
	СтруктураСкриптов.Вставить("main_kdb",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию + "main_kdb.js", "kdb_script", Ложь));
	
	Возврат СтруктураСкриптов;
	
КонецФункции

Процедура ОбработатьОбщиеСкриптыИнтернет(СтруктураСкриптов, ТекстHTML)
КонецПроцедуры

Процедура ОбработатьОбщиеСкриптыЛокально(СтруктураСкриптов, ТекстHTML)
	
	// Текст скрипта поставляется целиком
	ФайлыЗагрузки	= Новый Массив;
	Для Каждого КлючИЗначение Из СтруктураСкриптов Цикл
		ФайлыЗагрузки.Добавить(КлючИЗначение.Значение);
	КонецЦикла;
	ТекстыСкриптов	= БазаЗнанийВызовСервера.ПолучитьТекстыСкриптов(ФайлыЗагрузки);

	Если ТекстыСкриптов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстHTML = "";
	Для Каждого ТекстСкрипта Из ТекстыСкриптов Цикл
		ТекстHTML = ТекстHTML + ?(ПустаяСтрока(ТекстHTML), "", Символы.ПС) + 
			"<script type='text/javascript'>" + ТекстСкрипта + "</script>";
	КонецЦикла;

КонецПроцедуры

// Картинки

Процедура ОбработатьОбщиеКартинкиИнтернет(СтруктураФайлов)
КонецПроцедуры

Процедура ОбработатьОбщиеКартинкиЛокально(СтруктураФайлов)
	
	#Если Клиент Тогда
		РасширениеПодключено = ОбщегоНазначенияКлиент.РасширениеРаботыСФайламиПодключено(, "Отображение картинок невозможно.");
		Если НЕ РасширениеПодключено Тогда
			Возврат;
		КонецЕсли;
	#КонецЕсли
	
	ФайлыЗагрузки = Новый Массив;
	Для Каждого КлючИЗначение Из СтруктураФайлов Цикл
		СтруктураКартинки = КлючИЗначение.Значение;
		
		Файл = Новый Файл(СтруктураКартинки.Путь);
		Если НЕ Файл.Существует() Тогда
			ФайлыЗагрузки.Добавить(СтруктураКартинки);
		КонецЕсли;
	КонецЦикла;
	
	Если ФайлыЗагрузки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	#Если Клиент Тогда
		ПолучаемыеФайлы = БазаЗнанийВызовСервера.ПоместитьОбщиеКартинкиВХранилище(ФайлыЗагрузки);
		Результат = ПолучитьФайлы(ПолучаемыеФайлы, , , Ложь);
	#Иначе
		Результат = Ложь;
	#КонецЕсли
	
	Если НЕ Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Отображение картинок в статье невозможно.");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДопКартинкиИнтернет(СтруктураФайлов)
КонецПроцедуры

Процедура ОбработатьДопКартинкиЛокально(СтруктураФайлов)
	
	#Если Клиент Тогда
		РасширениеПодключено = ОбщегоНазначенияКлиент.РасширениеРаботыСФайламиПодключено(, "Отображение картинок в статье невозможно.");
		Если НЕ РасширениеПодключено Тогда
			Возврат;
		КонецЕсли;
	#КонецЕсли
	
	МассивОписаний = Новый Массив;
	Для Каждого КлючИЗначение Из СтруктураФайлов Цикл
		СтруктураФайла	= КлючИЗначение.Значение;
		Если НЕ ТипЗнч(СтруктураФайла) = Тип("Структура") Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеФайла 	= СтруктураФайла.ОписаниеФайла;
		ДатаОбновления	= СтруктураФайла.ДатаОбновления;
		
		Файл = Новый Файл(ОписаниеФайла.Имя);
		Если Файл.Существует() И Файл.ПолучитьВремяИзменения() >= ДатаОбновления Тогда
			Продолжить;
		КонецЕсли;
		
		МассивОписаний.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	Если МассивОписаний.Количество() > 0 Тогда
		#Если Клиент Тогда
			Результат = ПолучитьФайлы(МассивОписаний, , , Ложь);
			
			Для Каждого Описание Из МассивОписаний Цикл
				УдалитьИзВременногоХранилища(Описание.Хранение);
			КонецЦикла;
		#Иначе
			Результат = Ложь;
		#КонецЕсли
	Иначе 
		Результат = Истина;
	КонецЕсли;
	
	Если НЕ Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Отображение картинок в статье невозможно.");
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьОбщиеКартинки(ВидХранения, Каталог)
	
	КаталогПоУмолчанию = СокрЛП(Каталог);
	
	СтруктураКартинок = Новый Структура;
	СтруктураКартинок.Вставить("ДобавитьКатегорию", 
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "add_category.png"));
		
	СтруктураКартинок.Вставить("ДобавитьСтатью",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "add_article.png"));
		
	СтруктураКартинок.Вставить("Статья",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "article_32.png"));
		
	СтруктураКартинок.Вставить("Категория",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "category.png"));
		
	СтруктураКартинок.Вставить("КатегорияПубличная",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "category_share.png"));
		
	СтруктураКартинок.Вставить("Редактирование",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "edit.png"));
		
	СтруктураКартинок.Вставить("РедактированиеНедоступно",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "edit_lock.png"));
		
	СтруктураКартинок.Вставить("Путь",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "pathtree.png"));
		
	СтруктураКартинок.Вставить("ЗвездаПолная",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "star_full.png"));
		
	СтруктураКартинок.Вставить("Комментарии",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "comments.png"));
		
	СтруктураКартинок.Вставить("Пользователь",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "user_empty.png"));
		
	СтруктураКартинок.Вставить("Кнопка",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "pin.png"));
		
	СтруктураКартинок.Вставить("КнопкаЧБ",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "pin_gray.png"));
		
	СтруктураКартинок.Вставить("НовостьСоздание",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "news_create.png"));
		
	СтруктураКартинок.Вставить("НовостьИзменение",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "news_edit.png"));
		
	СтруктураКартинок.Вставить("НовостьУдаление",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "news_delete.png"));
		
	СтруктураКартинок.Вставить("НовостьОповещение",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "news_comments.png"));
		
	СтруктураКартинок.Вставить("НовостьПрочее",
		ПолучитьСтруктуруДанныхФайла(КаталогПоУмолчанию, "news_others.png"));
		
	Возврат СтруктураКартинок;
	
КонецФункции

Функция ПолучитьСтруктуруДанныхФайла(АдресКаталога, ИмяФайла, ДобавлятьИмя = Истина)
	
	Возврат Новый Структура("Путь, Имя", АдресКаталога + ?(ДобавлятьИмя, ИмяФайла, ""), ИмяФайла);
	
КонецФункции

