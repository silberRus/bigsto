﻿
#Область ВспомогательныеФункции

Функция ПолучитьЧисло(Текст)
	
	Если Не ПустаяСтрока(Текст) Тогда
		Попытка
			Возврат Число(Текст);
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

Процедура ДополнитьНомераКолонок(ДокументРезультат, ТабПравил)
	
	// Добавляет в таблицу правил номера колонк - соответсвие с именем колонки и ее колонкой в таблице
	// ТабПравил - таблица значений правил для поиска поля по представлению в табличном документе 
	//				чтобы идентифицировать номер колонки
	
	Соотв 		= Новый Соответствие;
	КолПолей 	= ТабПравил.Количество();
	
	Для НомерСтроки = 1 По ДокументРезультат.ВысотаТаблицы Цикл
		Для НомКолонки = 1 По ДокументРезультат.ШиринаТаблицы Цикл
			
			ТекущаяОбласть = ДокументРезультат.Область(НомерСтроки, НомКолонки);
			Текст = ДокументРезультат.Область(НомерСтроки, НомКолонки).Текст;
			Если Не ПустаяСтрока(Текст) Тогда
				
				Строка = ТабПравил.Найти(Текст, "Представление");
				Если Строка <> Неопределено И Не Строка.НомерКолонки Тогда
				
					Строка.НомерКолонки = НомКолонки;
					КолПолей = КолПолей - 1;
					
					Если Не КолПолей Тогда
						Возврат;
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	НеНайденные = СтрСоединить(КонвертацияТипов.ПолучитьМассивИзНайденныхЗначенийСтрокТаблицыЗначений(ТабПравил, Новый Структура("НомерКолонки", 0), "Представление"), "; ");
	ВызватьИсключение "Не удалось найти в шапке отчета названия колонок: " + НеНайденные;
	
КонецПроцедуры
Функция ПолучитьНомераКолонок(ДокументРезультат, Знач ИменаПолей)
	
	// Возвращает соответсвие с именем колонки и ее колонкой в таблице
	// ИменаПолей - массив внутри текст который написан в табличном документе 
	//				чтобы идентифицировать номер колонки
	
	Соотв 		= Новый Соответствие;
	КолПолей 	= ИменаПолей.Количество();
	
	Для НомерСтроки = 1 По ДокументРезультат.ВысотаТаблицы Цикл
		Для НомКолонки = 1 По ДокументРезультат.ШиринаТаблицы Цикл
			
			ТекущаяОбласть = ДокументРезультат.Область(НомерСтроки, НомКолонки);
			Текст = ДокументРезультат.Область(НомерСтроки, НомКолонки).Текст;
			Если Не ПустаяСтрока(Текст) И ИменаПолей.Найти(Текст) <> Неопределено Тогда
				
				Соотв.Вставить(Текст, НомКолонки);
				ИменаПолей.Удалить(ИменаПолей.Найти(Текст));
				
				Если Соотв.Количество() = КолПолей Тогда
					Возврат Соотв;
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ВызватьИсключение "Не удалось найти текст номер колонки по тексту:" + СтрСоединить(ИменаПолей, ", ");
	
КонецФункции
Функция СледующийРодитель(Элемент)
	
	// Движется к следующему родителю и возвращает его
	
	Родители = Элемент.ПолучитьРодителей();
	Если Родители.Количество() Тогда
		
		Элемент = Родители[0];
		Возврат ?(ТипЗнч(Элемент) = Тип("ЭлементРасшифровкиКомпоновкиДанныхГруппировка"),
					Элемент,
					СледующийРодитель(Элемент));
	КонецЕсли;
	
КонецФункции

Процедура ЗначениеДереваНаТаблицу(ТабличныйДокумент, СтрокаДерева, ИменаКолонок)
	
	Для Каждого Строка Из СтрокаДерева.Строки Цикл
		
		ЗначениеДереваНаТаблицу(ТабличныйДокумент, Строка, ИменаКолонок);
		
		Для Каждого Колонка Из ИменаКолонок Цикл
			ИмяОбласти = Строка[Колонка + "Коорд"];
			Если Не ПустаяСтрока(ИмяОбласти) Тогда
				ТабличныйДокумент.Область(ИмяОбласти).Текст = Строка[Колонка + "Значение"];
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Программный_API

Функция ПолучитьСпарсинноеДерево(ДокументРезультат, ДанныеРасшифровки, ПоляПарсинга) Экспорт
	
	// ПоляПарсинга - структура в ключе имя поля, в значении представление поля в шапке
	//
	// Возвращает дерево значений которое будет
	//		- ИдРодителя - идентификатор группы
	//		- <ИмяПоля>Значение 	- число, значение
	//		- <ИмяПоля>Коорд 		- координаты ячейки в текстовом поле R1C1
	//
	// последняя строка в дереве на корневом уровни это итоговая строка
	
	ТипСтрока 	= Новый ОписаниеТипов("Строка");
	ТипЧисло 	= Новый ОписаниеТипов("Число");
	
	ТабПравил = Новый ТаблицаЗначений;
	ТабПравил.Колонки.Добавить("Имя", 			ТипСтрока);
	ТабПравил.Колонки.Добавить("Представление", ТипСтрока);
	ТабПравил.Колонки.Добавить("НомерКолонки", 	ТипЧисло);
	
	Для Каждого ЭлементПоля Из ПоляПарсинга Цикл
		НовСтрока = ТабПравил.Добавить();
		НовСтрока.Имя 			= ЭлементПоля.Ключ;
		НовСтрока.Представление = ЭлементПоля.Значение;
	КонецЦикла;
	
	ДополнитьНомераКолонок(ДокументРезультат, ТабПравил);
	
	СвятоеДерево = Новый ДеревоЗначений;
	Для Каждого Правило Из ТабПравил Цикл
		СвятоеДерево.Колонки.Добавить(Правило.Имя + "Значение",	ТипЧисло);
		СвятоеДерево.Колонки.Добавить(Правило.Имя + "Коорд",	ТипСтрока);
	КонецЦикла;
	
	Корень		= СвятоеДерево.Строки.Добавить();
	КешСтрок 	= Новый Соответствие;
	КешСтрок.Вставить("0", Корень);
	
	КолСтрок = ДокументРезультат.ПолучитьРазмерОбластиДанныхПоВертикали();
	Для Ном = 1 По КолСтрок Цикл
		
		ПервыйВход = Истина;
		Для Каждого Правило Из ТабПравил Цикл
			
			Коорд 	= СтрШаблон("R%1C%2", Формат(Ном, "ЧГ="), Формат(Правило.НомерКолонки, "ЧГ="));
			Область = ДокументРезультат.Область(Коорд);
			Если Область.Расшифровка <> Неопределено Тогда
				
				текРасшифровка = ДанныеРасшифровки.Элементы[Область.Расшифровка];
				
				Если ПервыйВход Тогда
					
					ПервыйВход 	= Ложь;
					Родитель 	= СледующийРодитель(текРасшифровка);
					ИдРодителя	= Строка(Родитель.Идентификатор);
					
					БратСтрока = КешСтрок[ИдРодителя];
					Если БратСтрока <> Неопределено Тогда
						СвятаяСтрока = ?(ИдРодителя = "0", Корень, БратСтрока.Родитель).Строки.Добавить();
					Иначе
						Пока Родитель <> Неопределено Цикл
							
							текИд = Строка(Родитель.Идентификатор);
							РодительСтрока = КешСтрок[текИд];
							Если РодительСтрока <> Неопределено Тогда
								СвятаяСтрока = РодительСтрока.Строки.Добавить();
								Прервать;
							КонецЕсли;
							
							Родитель = СледующийРодитель(Родитель);
						КонецЦикла;
					КонецЕсли;
					
					КешСтрок.Вставить(ИдРодителя, СвятаяСтрока);
					
				КонецЕсли;
				
				СвятаяСТрока[Правило.Имя + "Значение"] 	= ПолучитьЧисло(Область.Текст);
				СвятаяСТрока[Правило.Имя + "Коорд"] 	= Коорд;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ИндИтога = Корень.Строки.Количество() - 1;
	Если ИндИтога Тогда
		ЗаполнитьЗначенияСвойств(Корень, Корень.Строки[ИндИтога]);
		Корень.Строки.Удалить(ИндИтога);
	КонецЕсли;
	
	Возврат СвятоеДерево;
	
КонецФункции

Процедура ОбновитьТабличныйДокументИзДерева(ТабличныйДокумент, Дерево) Экспорт
	
	// Обновляет данные из дерева в табличную часть
	// берет значения из дерева и пихает их в ТабличныйДокумент
	//
	// Дерево должно быть с колонками
	//		- <ИмяПоля>Значение 	- число, значение
	//		- <ИмяПоля>Коорд 		- координаты ячейки в текстовом поле R1C1
	
	ИменаКолонок = Новый Массив;
	Для Каждого Колонка Из Дерево.Колонки Цикл
		Если СтрЗаканчиваетсяНа(Колонка.Имя, "Значение") Тогда
			ИменаКолонок.Добавить(Лев(Колонка.Имя, СтрДлина(Колонка.Имя) - 8));
		КонецЕсли;
	КонецЦикла;
	
	ЗначениеДереваНаТаблицу(ТабличныйДокумент, Дерево, ИменаКолонок);
	
КонецПроцедуры

Процедура РассчитатьДеревоПоСреднему(СтрокаДерева, ИменаКолонок) Экспорт
	
	// Расчитывает показатели по среднему
	//	считает снизу вверх
	//
	// ТабличныйДокумент - 
	// ИменаКолонок - массив имен колонок где надо расчитать по среднему
	
	КолСтрок = СтрокаДерева.Строки.Количество();
	Если КолСтрок Тогда
		
		Для Каждого Строка ИЗ СтрокаДерева.Строки Цикл
			РассчитатьДеревоПоСреднему(Строка, ИменаКолонок);
		КонецЦикла;
		
		Если ТипЗнч(СтрокаДерева) <> Тип("ДеревоЗначений") Тогда
			Для Каждого ИмяКолонки Из ИменаКолонок Цикл
				Колонка = ИмяКолонки + "Значение";
				СтрокаДерева[Колонка] = СтрокаДерева.Строки.Итог(Колонка) / КолСтрок;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
Процедура РассчитатьДеревоПоПроизвольномуТексту(СтрокаДерева, АлгоритмСтрок) Экспорт
	
	// Расчитывает показатели по поизвольному алгоритму
	//	считает снизу вверх
	
	Для Каждого Строка ИЗ СтрокаДерева.Строки Цикл
		
		РассчитатьДеревоПоПроизвольномуТексту(Строка, АлгоритмСтрок);
		Выполнить(АлгоритмСтрок);
			
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
