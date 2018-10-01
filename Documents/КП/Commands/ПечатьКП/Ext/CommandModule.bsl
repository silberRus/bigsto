﻿
&НаСервере
Процедура ВывестиОбласти(ТабличныйДокумент, Области)
	
	Для Каждого Область Из Области Цикл ТабличныйДокумент.Вывести(Область) КонецЦикла;
	
КонецПроцедуры
&НаСервере
Процедура ДобитьПустымиСтрокамиДоКонцаСтраницы(ТабличныйДокумент, ОбластьПустаяСтрока, ОбластиНиз) Экспорт
	
	// Проверим войдет ли с подвалом и колонтитулом если вывести эту строку
	
	ОбластиПроверки = Новый Массив;
	ОбластиПроверки.Добавить(ОбластьПустаяСтрока);
	КонвертацияТипов.ДобавитьМассивВКонецМассива(ОбластиПроверки, ОбластиНиз);
	
	Пока Истина Цикл
		
		Если ТабличныйДокумент.ПроверитьВывод(ОбластиПроверки) Тогда 
			ТабличныйДокумент.Вывести(ОбластьПустаяСтрока);
			
		Иначе 
			ВывестиОбласти(ТабличныйДокумент, ОбластиНиз);
			Прервать;  КонецЕсли;  КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьДанныеКП(СсылкаКП)
	
	//Запрос = Новый Запрос("
	//|ВЫБРАТЬ Ссылка, Номер, Дата, Партнер ,Сделка, Валюта, СуммаДокумента, ГрафикОплаты, ДокументОснование,
	//|	СрокДействия, Менеджер, Соглашение, СрокПоставки,
	//|	ЦенаВключаетНДС, Статус, Согласован, Склад, Организация, КонтактноеЛицо,
	//|	НалогообложениеНДС, ФормаОплаты, Комментарий,
	//|	КартаЛояльности, СпособДоставки, Автор, ДатаОтгрузки, БП_АдресДоставкиСсылка,БП_АдресДоставкиПеревозчикаСсылка,
	//|	ПеревозчикПартнер, АдресДоставки, ЗонаДоставки,
	//|	ВремяДоставкиС, ВремяДоставкиПо, ОсобыеУсловияПеревозки, ОсобыеУсловияПеревозкиОписание,
	//|	АдресДоставкиПеревозчика, АдресДоставкиЗначенияПолей, АдресДоставкиПеревозчикаЗначенияПолей, ДополнительнаяИнформацияПоДоставке, Представление,
	//|	Менеджер ОтветСтвенный,
	//|	Товары.(
	//|		НомерСтроки, Номенклатура.Наименование Наименование,
	//|		Склад, Номенклатура, Характеристика,
	//|		Номенклатура.Производитель Производитель,
	//|		Упаковка, КоличествоУпаковок, Количество,
	//|		ВидЦены, Цена,
	//|		ВЫБОР КОГДА Количество = 0 ТОГДА 0 ИНАЧЕ (СуммаСНДС - СуммаРучнойСкидки - СуммаАвтоматическойСкидки) / Количество КОНЕЦ ЦенаСоСкидкой,
	//|		ПроцентРучнойСкидки, СуммаРучнойСкидки, ПроцентАвтоматическойСкидки, СуммаАвтоматическойСкидки,
	//|		СтавкаНДС, СуммаНДС, СуммаСНДС, Сумма,
	//|		Активность, ТекстовоеОписание, ЭтоПерекуп, Комментарий
	//|	) КАК Товары
	//|ИЗ
	//|	Документ.КП
	//|ГДЕ
	//|	Ссылка = &Ссылка
	//|");
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ Ссылка, Номер, Дата, Партнер, Валюта, ЦенаВключаетНДС, Организация,
	|	Менеджер ОтветСтвенный,
	|	Товары.(
	|		Активность,
	|		НомерСтроки, Номенклатура.Наименование Наименование,
	|		Номенклатура,
	|		Номенклатура.Производитель Производитель,
	|		Количество,
	|		Цена,
	|		ВЫБОР КОГДА Количество = 0 ТОГДА 0 ИНАЧЕ СуммаСНДС / Количество КОНЕЦ ЦенаСоСкидкой,
	|		СуммаРучнойСкидки + СуммаАвтоматическойСкидки СуммаСкидки,
	|		СуммаНДС, СуммаСНДС, Сумма
	|	) КАК Товары
	|ИЗ
	|	Документ.КП
	|ГДЕ
	|	Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО Товары.НомерСтроки
	|");
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаКП);
	Табл = Запрос.Выполнить().Выгрузить();
	
	Возврат Новый Структура("РезультатПоШапке, РезультатПоТабличнойЧасти",
					КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Табл), Табл[0].Товары);
КонецФункции

&НаСервере
Функция СформироватьПечатнуюФормуКП(МассивОбъектов)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	//Если Не ПривилегированныйРежим() Тогда
	//	УстановитьПривилегированныйРежим(Ложь);
	//КонецЕсли;
	
	Для Каждого СсылкаКП Из МассивОбъектов Цикл
		ЗаполнитьТабличныйДокументКП(ТабличныйДокумент, ПолучитьДанныеКП(СсылкаКП));
	КонецЦикла;
	
	//Если ПривилегированныйРежим() Тогда
	//	УстановитьПривилегированныйРежим(Ложь);
	//КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции
&НаСервере
Процедура ЗаполнитьТабличныйДокументКП(ТабличныйДокумент, ДанныеДляПечати)
	
	// Иницилизация переменных
	
	ПараметрПечати = Новый Структура("СкидкаВТаблице, НаПервомНеБолее, НаВторомНеБолее, ВКонцеНеБолее, _1ЛистТолькоКогдаДо, СтрокаУсловиеПоставки", 
											Ложь, 		8, 					9, 				7, 				6, 					ложь);
								
	Макет 			= Документы.КП.ПолучитьМакет("КП");
	СтруктураШапки  = ДанныеДляПечати.РезультатПоШапке;
	Таблица 		= ДанныеДляПечати.РезультатПоТабличнойЧасти;
	ЕстьСкидка 		= Булево(Таблица.Итог("СуммаСкидки"));
	//ПечатьСНаличием	= СтруктураШапки.Свойство("ПечатьСНаличием") И СтруктураШапки.ПечатьСНаличием И Макет.Области.Найти("СтрокаНаличие") <> Неопределено;
	ПечатьСНаличием = Ложь;
	СоСкидками = Ложь;
	ИмяДопИмениОбластей = "";
	ЦенаОтСуммы = Ложь;
	
	//КонвертацияТипов.ВыполнитьВыражениеВКаждойСтрокеТаблицы(Таблица, "
	//|Строка.НомерСтроки = Инд + 1; 
	//|Если Не Строка.СуммаСНДС Тогда Строка.СуммаСНДС = Строка.Сумма" + ?(СтруктураШапки.ЦенаВключаетНДС,""," + Строка.СуммаНДС") + " КонецЕсли;
	//|Строка.СуммаБезНДС = Строка.Сумма" + ?(СтруктураШапки.ЦенаВключаетНДС," - Строка.СуммаНДС", ""));
	
	СтруктураПодвала = Новый Структура("ТекстИтогоБезНДС, ВсегоНаименований, СуммаПрописью, Сумма, СуммаНДС, Скидка, Итого, СуммаБезНДС",
						"Итого без НДС" + ?(ЕстьСкидка, " (с учетом скидки)", ""),
						"Всего наименований " + Таблица.Количество() + ", на сумму " + Таблица.Итог("Сумма") + " " + СтруктураШапки.Валюта,
						РаботаСКурсамиВалют.СформироватьСуммуПрописью(Таблица.Итог("СуммаСНДС"), СтруктураШапки.Валюта, Истина),
						Таблица.Итог("Сумма") , 
						Таблица.Итог("СуммаНДС"), 
						Таблица.Итог("СуммаСкидки"), 
						Таблица.Итог("СуммаСНДС"), 
						Таблица.Итог("Сумма") - Таблица.Итог("СуммаНДС"));
						
	// Подготовим переменные
	
	//ТабличныйДокумент.ОриентацияСтраницы = ПараметрПечати.ОриентацияСтраницы;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	//ДобСуффикс = ?(ЕстьСкидка И СоСкидками И НЕ СтруктураШапки.НеВыводьКолонкуСкидкаВПечатнойФорме, "Скидка", "");
	ДобСуффикс = ЕстьСкидка И СоСкидками;
	

	ОбластьВКолонтитул 	= Макет.ПолучитьОбласть("ВерхнийКолонтитул");
	ОбластьВКолонтитул2	= Макет.ПолучитьОбласть("ВерхнийКолонтитул2");
	//Если ПараметрПечати.СтрокаУсловиеПоставки Тогда ОбластьУсловия = Макет.ПолучитьОбласть("Условия") 
	//КонецЕсли;
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы" 	+ ?(ПечатьСНаличием, "Наличие", "") + ?(ПараметрПечати.СкидкаВТаблице, ДобСуффикс, ""));
	ОбластьСтрока 		= Макет.ПолучитьОбласть("Строка" 		+ ?(ПечатьСНаличием, "Наличие", "") + ?(ПараметрПечати.СкидкаВТаблице, ДобСуффикс, ""));
	ОбластьПустаяСтрока	= Макет.ПолучитьОбласть("ПустаяСтрока");
	ОбластьШапка 		= Макет.ПолучитьОбласть("Шапка");
	ОбластьПодвал		= Макет.ПолучитьОбласть("ПодвалТаблицы" + ?(ПараметрПечати.СкидкаВТаблице, ДобСуффикс, ""));
		
	ОбластьПодпись		= Макет.ПолучитьОбласть("Подпись" + ИмяДопИмениОбластей);
	
	Если СокрЛП(ИмяДопИмениОбластей)<>"" Тогда
		ОбластьПодпись.Параметры.ФИОРуководителя = ФормированиеПечатныхФорм.ФамилияИнициалыФизЛица(ДанныеДляПечати.Шапка.ФизическоеЛицо);
	КонецЕсли;
	
	ОбластьШапкаТаблицы.Параметры.ЦенаЗаголовок = "Цена";
	
	ОбластьШапкаТаблицы.Параметры.Заполнить(СтруктураШапки);
	ОбластьШапка.Параметры.Заполнить(СтруктураШапки); 
	ОбластьПодвал.Параметры.Заполнить(СтруктураПодвала);
	
	// Пдоготви набор областей
	
	ОбластиПоследнейСтраницы = Новый Массив; 
	ОбластиПоследнейСтраницы.Добавить(ОбластьПодвал); 
	ОбластиПоследнейСтраницы.Добавить(ОбластьПодпись);
	//Если ПараметрПечати.СтрокаУсловиеПоставки Тогда ОбластьМеждуПодписьюИУсловиями = Новый Массив; ОбластьМеждуПодписьюИУсловиями.Добавить(ОбластьУсловия) 
	//КонецЕсли;
	
	// Рассчитаем и заполним параметры
	
	КолСтрок = Таблица.Количество();
	
	// Расчитаем текстовые переменные
	
	//СтруктураОтветвенного = ПолучитьИнфуПоОтветвенному(СтруктураШапки.Ответственный);
	//СтруктураШапки.Вставить("КонтактОтветвенного", "тел.: " + ?(СтруктураОтветвенного.Свойство("Телефон"), СтруктураОтветвенного.Телефон, "8 (812) 620-80-07") + 
	//	?(СтруктураОтветвенного.Свойство("Почта"), "; e-mail: " + СтруктураОтветвенного.Почта, ""));
	//	
	//ТекстДляКолонтитула = ПолучитьТекстовыеДанныеПоЮрЛицу(?(СтруктураШапки.Свойство("Грузоотправитель") И ЗначениеЗаполнено(СтруктураШапки.Грузоотправитель), СтруктураШапки.Грузоотправитель, СтруктураШапки.Организация), ПараметрПечати.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт);
	
	
	
	// Выведем колонтитул
	
	ДатаСтрокой = Формат(СтруктураШапки.Дата, "ДЛФ=DD");
	ОбластьВКолонтитул.Параметры.Заполнить(СтруктураШапки);
	ОбластьВКолонтитул.Параметры.Дата = ДатаСтрокой;
	
	ОбластьВКолонтитул2.Параметры.Заполнить(СтруктураШапки);
	ОбластьВКолонтитул2.Параметры.Дата = ДатаСтрокой;
	
	ОбластьПодпись.Параметры.Заполнить(СтруктураШапки);
	
	// Считаем информацию об ответвенном
		
	ТабличныйДокумент.Вывести(ОбластьВКолонтитул);
	
	// Выведем шапку
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	ЕстьНомКартинки = Таблица.Колонки.Найти("НоменклатураКартинки") <> Неопределено;
	
	// Выведем строки
	
	текСтраница = 1; ПозНаЛисте = 0;
	счетчикСтрок=0;
	Для Каждого Строка Из Таблица Цикл 
		Если Строка.Активность Тогда
			
			ПозНаЛисте = ПозНаЛисте + 1;
		
			СчетчикСтрок = СчетчикСтрок + 1;
			
			ОбластьСтрока.Параметры.Заполнить(Строка);
			Если ЦенаОтСуммы Тогда
				 ОбластьСтрока.Параметры.Цена = Окр(Строка.Сумма/Строка.Количество, 2); 
			 КонецЕсли;
			 
			// Вытащим артикул из названий
			
			начАртикул = СтрНайти(Строка.Наименование, "арт.");
			Если начАртикул Тогда
				ОбластьСтрока.Параметры.Номенклатура = СокрЛП(Лев(Строка.Наименование, начАртикул - 1));
				ОбластьСтрока.Параметры.Артикул = СокрЛП(Сред(Строка.Наименование, начАртикул + 5));
			КонецЕсли;
			 
			// Картинка
			
			//СсылкаКартинки = Картинки.ПолучитьСсылкуОсновногоИзображения(?(ЕстьНомКартинки И Не Строка.НоменклатураКартинки.Пустая(), Строка.НоменклатураКартинки, Строка.Номенклатура));
			Если ЗначениеЗаполнено(Строка.Номенклатура.ФайлКартинки) Тогда
			//Если СсылкаКартинки <> Неопределено Тогда
				//+Андриянов 09.07.2017 добавляем ещё один вид картинки
				//Карт = Картинки.ПолучитьВариантКартинки(СсылкаКартинки, Ложь);
				//Карт = ?(СсылкаКартинки.КопияКартинки.Пустая(), ?(СсылкаКартинки.Аватар.Получить()=Неопределено, СсылкаКартинки.Картинка.Получить(), СсылкаКартинки.Аватар.Получить()), ?(СсылкаКартинки.КопияКартинки.Аватар.Получить()=Неопределено,СсылкаКартинки.КопияКартинки.Картинка.Получить(),СсылкаКартинки.КопияКартинки.Аватар.Получить()));
				//Карт = ?(СсылкаКартинки.КопияКартинки.Пустая(), ?(СсылкаКартинки.Аватар.Получить()=Неопределено, СсылкаКартинки.Картинка.Получить(), СсылкаКартинки.Аватар.Получить()), СсылкаКартинки.КопияКартинки.Аватар.Получить());
				//-Андриянов
				//Карт = ?(СсылкаКартинки.КопияКартинки.Пустая(), СсылкаКартинки.Аватар.Получить(), СсылкаКартинки.КопияКартинки.Аватар.Получить());
				
				Попытка
					КартинкаНоменклатуры = ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(Строка.Номенклатура.ФайлКартинки);
				Исключение
					КартинкаНоменклатуры = Неопределено; 
				КонецПопытки;
				
				Если ЗначениеЗаполнено(КартинкаНоменклатуры) Тогда
					
					Если ТипЗнч(КартинкаНоменклатуры) = Тип("Картинка") Тогда
						ОбластьСтрока.Область("R1C2").Картинка = КартинкаНоменклатуры;
					ИначеЕсли ТипЗнч(КартинкаНоменклатуры) = Тип("ДвоичныеДанные") Тогда
						ОбластьСтрока.Область("R1C2").Картинка = Новый Картинка(КартинкаНоменклатуры);
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;
			
			// Вывод
			
			ТабличныйДокумент.Вывести(ОбластьСтрока); 
			Если 	(текСтраница = 1 И Строка.НомерСтроки = ПараметрПечати.НаПервомНеБолее) Или 
					(Строка.НомерСтроки > 1 И Строка.НомерСтроки = ПараметрПечати.НаВторомНеБолее * (текСтраница - 1) + ПараметрПечати.НаПервомНеБолее) Тогда 
					
				текСтраница = текСтраница + 1;
				ПозНаЛисте 	= 0;
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьВКолонтитул2); 
				
				Если Строка.НомерСтроки <> КолСтрок Тогда
					ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы); 
				КонецЕсли; 
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
		
	Если 	ПозНаЛисте > ПараметрПечати.ВКонцеНеБолее Или 
			(ПараметрПечати._1ЛистТолькоКогдаДо < КолСтрок И КолСтрок <= ПараметрПечати.НаПервомНеБолее) Тогда 
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц(); 
	КонецЕсли;
		
	// Выведем подвал
	
	ВывестиОбласти(ТабличныйДокумент, ОбластиПоследнейСтраницы);
	Если ПараметрПечати.СтрокаУсловиеПоставки Тогда
		//ДобитьПустымиСтрокамиДоКонцаСтраницы(ТабличныйДокумент, ОбластьПустаяСтрока, ОбластьМеждуПодписьюИУсловиями); 
		ДобитьПустымиСтрокамиДоКонцаСтраницы(ТабличныйДокумент, ОбластьПустаяСтрока, ОбластьПустаяСтрока); 
	КонецЕсли;
	
	// Нижний колонтитул
	
	//ТабличныйДокумент = Новый ТабличныйДокумент;
	
	//ТабличныйДокумент.НижнийКолонтитул.ТекстСлева = "Исполнитель: " + ТекстДляКолонтитула;
	ТабличныйДокумент.НижнийКолонтитул.ТекстСправа 	= "Страница [&НомерСтраницы] Из [&СтраницВсего]";
	ТабличныйДокумент.НижнийКолонтитул.Шрифт 		= Новый Шрифт("Arial", 8);
	ТабличныйДокумент.НижнийКолонтитул.Выводить 	= Истина;
	ТабличныйДокумент.ОтображатьСетку 				= ложь;
	ТабличныйДокумент.ОтображатьЗаголовки 			= ложь;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СформироватьПечатнуюФормуКП(ПараметрКоманды).Показать();
	
КонецПроцедуры
