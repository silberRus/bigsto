﻿
#Область ПрограммныйИнтерфейс

Функция ОбработатьЗагружаемыеДанныеИзККМ(ТекстовыйДокумент, ВыходныеПараметры) Экспорт
	
	Результат = Истина;
	
	ВсегоСтрок = ТекстовыйДокумент.КоличествоСтрок();
	
	ЗагружаемыеДанныеИзККМ = МенеджерОфлайнОборудования.ПолучитьЗагружаемыеДанныеИзККМ();
	
	ПродолжатьЧтениеФайла = Ложь;
	ТекстОшибки = "";
	Строка = ТекстовыйДокумент.ПолучитьСтроку(1);
	
	// Проверяем обработанность файла.
	Если Строка = "#" Тогда
		Индекс = 4;
		ПродолжатьЧтениеФайла = Истина;
	ИначеЕсли Строка = "@" Тогда
		ТекстОшибки = НСтр("ru='Файл загрузки был обработан ранее.'");
		Результат = Ложь;
	Иначе
		ТекстОшибки = НСтр("ru='Загрузка невозможна. Неизвестный формат отчета.'");
		Результат = Ложь;
	КонецЕсли;
	
	Смены = Новый Массив;
	ТекущаяСмена = Неопределено;
	ВозвращаемыеЧеки = Новый Массив;
	ОткрытТэг = Ложь;
	
	
	// В цикле читаем транзакции.
	Пока ПродолжатьЧтениеФайла Цикл
		
		// Получаем строку с очередной транзакцией.
		Строка = ТекстовыйДокумент.ПолучитьСтроку(Индекс);
		
		Если Строка = "#" Тогда
			Индекс = Индекс + 3;
			Продолжить;
		КонецЕсли;
		
		// Все строки с тэгами и внутри тэгов пропускаются.
		Если Лев(Строка, 1) = "<" Тогда
			
			Если Лев(Строка, 2) = "</" Тогда
				ОткрытТэг = Ложь;
			Иначе
				ОткрытТэг = Истина;
			КонецЕсли;
			
			Индекс = Индекс + 1;
			Продолжить;
		КонецЕсли;
		
		Если ОткрытТэг Тогда
			Индекс = Индекс + 1;
			Продолжить;
		КонецЕсли;
		
		// Если транзакция существует.
		Если ПустаяСтрока(Строка) Тогда
			
			Если Индекс <= ВсегоСтрок Тогда
				Индекс = Индекс + 1;
				Продолжить;
			КонецЕсли;
			
			ПродолжатьЧтениеФайла = Ложь;
			
		Иначе
			
			Транзакция = Новый Структура;
			
			// Раскладываем транзакцию на поля.
			
			ТранзакцияЗаполнена = ЗаполнитьТранзакцию(СтрЗаменить(Строка, ";", Символы.ПС), Транзакция, ТекстОшибки);
			
			Если НЕ ТранзакцияЗаполнена Тогда
				
				Индекс = Индекс + 1;
				Продолжить;
				
			КонецЕсли;
			
			Если Транзакция.Тип = 1 ИЛИ Транзакция.Тип = 11 Тогда
				// Продажа товара.
				ДобавитьТранзакциюВЧек(ТекущаяСмена, Смены, Транзакция);
			ИначеЕсли Транзакция.Тип = 2 ИЛИ Транзакция.Тип = 12 Тогда
				// Сторно продажи/возврата товара.
				Если НЕ УдалитьТранзакциюИзЧека(ТекущаяСмена, Транзакция, ТекстОшибки) Тогда
					ПродолжатьЧтениеФайла = Ложь;
					Результат = Ложь;
				КонецЕсли;
			ИначеЕсли Транзакция.Тип = 3 ИЛИ Транзакция.Тип = 4 ИЛИ Транзакция.Тип = 13 ИЛИ Транзакция.Тип = 14 Тогда
				// Возврат товара.
				ДобавитьТранзакциюВЧек(ТекущаяСмена, Смены, Транзакция);
			ИначеЕсли Транзакция.Тип = 40 Тогда
				// Оплата.
				ДобавитьТранзакциюВЧек(ТекущаяСмена, Смены, Транзакция, Истина);
			ИначеЕсли Транзакция.Тип = 15 ИЛИ Транзакция.Тип = 16 ИЛИ Транзакция.Тип = 17 ИЛИ Транзакция.Тип = 18 Тогда
				// Скидка / надбавка на товар.
				Если НЕ ДобавитьСкидкуНаТовар(ТекущаяСмена, Транзакция, ТекстОшибки) Тогда
					ПродолжатьЧтениеФайла = Ложь;
					Результат = Ложь;
				КонецЕсли;
			ИначеЕсли Транзакция.Тип = 35 ИЛИ Транзакция.Тип = 36 ИЛИ Транзакция.Тип = 37 ИЛИ Транзакция.Тип = 38 Тогда
				// Скидка / надбавка на чек.
				Если НЕ ДобавитьСкидкуНаЧек(ТекущаяСмена, Транзакция, ТекстОшибки) Тогда
					ПродолжатьЧтениеФайла = Ложь;
					Результат = Ложь;
				КонецЕсли;
			ИначеЕсли Транзакция.Тип = 55 Тогда
				// Закрытие чека.
				Если НЕ ЗакрытьЧек(ТекущаяСмена, Транзакция, ТекстОшибки) Тогда
					ПродолжатьЧтениеФайла = Ложь;
					Результат = Ложь;
				КонецЕсли;
			ИначеЕсли Транзакция.Тип = 56 Тогда
				// Отмена чека.
				УдалитьЧек(ТекущаяСмена, Транзакция, ТекстОшибки);
			ИначеЕсли Транзакция.Тип = 61 Тогда
				// Z-отчет (закрытие смены).
				ЗакрытьСмену(ТекущаяСмена, Смены, Транзакция);
			ИначеЕсли Транзакция.Тип = 80 Тогда
				// Возврат по номерам чека и транзакции.
				Если НЕ ВозвратПоНомеруЧека(ТекущаяСмена, Смены, Транзакция, ТекстОшибки) Тогда
					ПродолжатьЧтениеФайла = Ложь;
					Результат = Ложь;
				КонецЕсли;
			ИначеЕсли Транзакция.Тип = 160 Тогда
				// Акцизный товар.
				Если НЕ ДобавитьШтрихкодМарки(ТекущаяСмена, Транзакция, ТекстОшибки) Тогда
					ПродолжатьЧтениеФайла = Ложь;
					Результат = Ложь;
				КонецЕсли;
			КонецЕсли;
			
			
		КонецЕсли;
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	Если Результат Тогда
		
		// Перебираем смены.
		Для Каждого Смена Из Смены Цикл
			
			ОтчетОПродажахККМ = МенеджерОфлайнОборудования.ПолучитьОтчетОПродажахККМ();
			
			ОтчетОПродажахККМ.НомерСмены = Смена.Номер;
			ОтчетОПродажахККМ.ДатаОткрытияСмены = Смена.ДатаОткрытия;
			ОтчетОПродажахККМ.ДатаЗакрытияСмены = Смена.ДатаЗакрытия;
			
			// Перебираем все чеки смены.
			Для Каждого Чек Из Смена.Чеки Цикл
				
				// Если чек закрыт.
				Если Чек.Закрыт Тогда
					
					ЧекККМ = МенеджерОфлайнОборудования.ПолучитьЧекККМ();
					
					ЧекККМ.ДатаЧека = Чек.ДатаЧека;
					ЧекККМ.НомерЧека = Чек.НомерЧека;
					
					// Перебираем продажи/возвраты товаров чека.
					Для Каждого Товар Из Чек.Товары Цикл
						
						Если НЕ Товар.Количество = 0 Тогда
							
							ТоварЧекаККМ = МенеджерОфлайнОборудования.ПолучитьТоварЧекаККМ();
							
							ТоварЧекаККМ.Код 		= Товар.Код;
							ТоварЧекаККМ.Цена 		= Товар.Цена;
							ТоварЧекаККМ.Сумма 		= Товар.Сумма;
							ТоварЧекаККМ.Количество = Товар.Количество;
							
							Если ЗначениеЗаполнено(Товар.ШтрихкодАлкогольнойПродукции) Тогда
								ТоварЧекаККМ.ШтрихкодАлкогольнойПродукции.Добавить(Товар.ШтрихкодАлкогольнойПродукции);
							КонецЕсли;
							
							ТоварЧекаККМ.ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой;
							
							ЧекККМ.Товары.Добавить(ТоварЧекаККМ);
							
						КонецЕсли;
						
					КонецЦикла;
					
					Для Каждого Оплата Из Чек.Оплаты Цикл
						
						ОплатаЧекаККМ = МенеджерОфлайнОборудования.ПолучитьОплатуЧекаККМ();
						
						Если Оплата.ТипОплаты = "0" Тогда
							ОплатаЧекаККМ.СуммаНаличнойОплаты = Оплата.Сумма;
						Иначе
							ОплатаЧекаККМ.СуммаЭлектроннойОплаты = Оплата.Сумма;
						КонецЕсли;
						
						ЧекККМ.Оплаты.Добавить(ОплатаЧекаККМ);
						
					КонецЦикла;
					
					ОпределитьТипРасчетаЧека(ЧекККМ);
					
					ОтчетОПродажахККМ.Чеки.Добавить(ЧекККМ);
					
				КонецЕсли;
				
			КонецЦикла;
			
			ЗагружаемыеДанныеИзККМ.ОтчетыОПродажах.Добавить(ОтчетОПродажахККМ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Результат Тогда
		ВыходныеПараметры.Добавить(ЗагружаемыеДанныеИзККМ);
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ТекстОшибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОпределитьТипРасчетаЧека(ЧекККМ)
	
	// если оплата с минусом, то это чек на возврат
	
	ЭтоВозврат = Ложь;
	
	Для Каждого Оплата Из ЧекККМ.Оплаты Цикл
		
		Если Оплата.СуммаНаличнойОплаты < 0 ИЛИ Оплата.СуммаЭлектроннойОплаты < 0 Тогда
			
			ЧекККМ.ТипРасчета = Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств;
			ЭтоВозврат = Истина;
			
			Прервать;
		Иначе
			ЧекККМ.ТипРасчета = Перечисления.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств;
			Прервать;
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
	
	Если НЕ ЭтоВозврат Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Оплата Из ЧекККМ.Оплаты Цикл
		
		Если Оплата.СуммаНаличнойОплаты < 0 Тогда
			Оплата.СуммаНаличнойОплаты = -Оплата.СуммаНаличнойОплаты;
		КонецЕсли;
		
		Если Оплата.СуммаЭлектроннойОплаты < 0 Тогда
			Оплата.СуммаЭлектроннойОплаты = -Оплата.СуммаЭлектроннойОплаты;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаТовар Из ЧекККМ.Товары Цикл
		
		Если СтрокаТовар.Количество < 0 Тогда
			СтрокаТовар.Количество = -СтрокаТовар.Количество;
		КонецЕсли;
		
		Если СтрокаТовар.Сумма < 0 Тогда
			СтрокаТовар.Сумма = -СтрокаТовар.Сумма;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьТранзакциюВЧек(Смена, Смены, Транзакция, Оплата = Ложь)
	
	Если Смена = Неопределено ИЛИ ЗначениеЗаполнено(Смена.ДатаЗакрытия) Тогда
		ОткрытьСмену(Смена, Смены, Транзакция);
	КонецЕсли;
	
	ТекущийЧек = ПолучитьЧек(Смена, Транзакция.НомерЧека);
	
	Если ТекущийЧек = Неопределено Тогда
		
		ОткрытьЧек(Смена, Смены, Транзакция);
		ТекущийЧек = Смена.Чеки[Смена.Чеки.Количество()-1];
		
	КонецЕсли;
	
	Если Оплата Тогда
		
		ОплатыЧека = ТекущийЧек.Оплаты;
		
		НайденныеОплаты = НайтиСтроки(ОплатыЧека, Новый Структура("КодВидаОплаты", Транзакция.Поле11));
		
		Если НайденныеОплаты.Количество() > 0 Тогда
			
			Оплата = ОплатыЧека[НайденныеОплаты[0].ИндексВМассиве];
			Оплата.Сумма = Оплата.Сумма + Транзакция.Поле12 - Транзакция.Поле10;	// Сумма оплаты = Сумма оплаты + Сумма оплаты транзакции - Сумма сдачи транзакции.
			
		Иначе
			
			НоваяОплата = Новый Структура;
			
			НоваяОплата.Вставить("ТипОплаты", ?(Транзакция.Поле11 = 1, "0", "1")); // 1 - предопределенный тип оплаты "наличные".
			НоваяОплата.Вставить("КодВидаОплаты", Транзакция.Поле11);
			НоваяОплата.Вставить("Сумма", Транзакция.Поле12 - Транзакция.Поле10);
			
			ОплатыЧека.Добавить(НоваяОплата);
			
		КонецЕсли;
		
	Иначе
		
		НовыйТовар = Новый Структура;
		
		НовыйТовар.Вставить("Код", Транзакция.Поле8);
		НовыйТовар.Вставить("Количество", Транзакция.Поле11);
		НовыйТовар.Вставить("Цена", Транзакция.Поле10);
		НовыйТовар.Вставить("Сумма", Транзакция.Поле12);
		НовыйТовар.Вставить("НомерТранзакции", Транзакция.Номер);
		НовыйТовар.Вставить("ДатаИВремяТранзакции", Транзакция.ДатаИВремя);
		НовыйТовар.Вставить("ШтрихкодАлкогольнойПродукции", "");
		
		ТекущийЧек.Товары.Добавить(НовыйТовар);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает массив элементов найденных в массиве структур по параметрам отбора. Параметры отбора являют собой
// структуру.
// Действует аналогично методу НайтиСтроки таблицы значений.
Функция НайтиСтроки(МассивПоиска, ПараметрыОтбора)
	
	Результат = Новый Массив;
	
	Для ВремИндекс = 0 По МассивПоиска.Количество()-1 Цикл
		
		ЭлементМассива = МассивПоиска[ВремИндекс];
		ПолноеСовпадение = Истина;
		
		Для каждого ЭлементОтбора Из ПараметрыОтбора Цикл
			
			Если ЭлементМассива.Свойство(ЭлементОтбора.Ключ) 
				И НЕ ЭлементОтбора.Значение = ЭлементМассива[ЭлементОтбора.Ключ] Тогда
				ПолноеСовпадение = Ложь;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ПолноеСовпадение Тогда
			ЭлементМассива.Вставить("ИндексВМассиве", ВремИндекс);
			Результат.Добавить(ЭлементМассива);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ОткрытьЧек(Смена, Смены, Транзакция)
	
	// Проверяем инициализированность текущей смены.
	Если Смена = Неопределено ИЛИ ЗначениеЗаполнено(Смена.ДатаЗакрытия) Тогда
		ОткрытьСмену(Смена, Смены, Транзакция);
	КонецЕсли;
	
	Чек = Новый Структура;
	
	Чек.Вставить("Закрыт", Ложь);
	Чек.Вставить("НомерЧека", Транзакция.НомерЧека);
	Чек.Вставить("ДатаЧека"); // заполняется при закрытии чека
	Чек.Вставить("Товары", Новый Массив);
	Чек.Вставить("Оплаты", Новый Массив);
	
	Смена.Чеки.Добавить(Чек);
	
КонецПроцедуры

Функция ПолучитьЧек(Смена, НомерЧека)
	
	НайденныеЧеки = НайтиСтроки(Смена.Чеки, Новый Структура("НомерЧека", НомерЧека));
	
	Если НайденныеЧеки.Количество()>0 Тогда
		Возврат Смена.Чеки[НайденныеЧеки[0].ИндексВМассиве];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Процедура ОткрытьСмену(Смена, Смены, Транзакция)
	
	// Если предыдущая смена не закрыта, закрываем ее.
	Если Смена<>Неопределено И НЕ ЗначениеЗаполнено(Смена.ДатаЗакрытия) Тогда
		ЗакрытьСмену(Смена, Смены, Транзакция);
	КонецЕсли;
	
	Смена = Новый Структура;
	
	Смена.Вставить("Номер");
	Смена.Вставить("ДатаОткрытия", Транзакция.ДатаИВремя);
	Смена.Вставить("ДатаЗакрытия");
	Смена.Вставить("Чеки", Новый Массив);
	
КонецПроцедуры

Процедура ЗакрытьСмену(Смена, Смены, Транзакция)
	
	// Если смена не открыта/закрыта, открываем ее.
	Если Смена=Неопределено ИЛИ ЗначениеЗаполнено(Смена.ДатаЗакрытия) Тогда
		ОткрытьСмену(Смена, Смены, Транзакция);
	КонецЕсли;
	
	Смена.Номер = Транзакция.Поле8;
	Смена.ДатаЗакрытия = Транзакция.ДатаИВремя;
	Смены.Добавить(Смена);
	
КонецПроцедуры

Функция ЗакрытьЧек(Смена, Транзакция, ТекстОшибки)
	
	ТекущийЧек = ПолучитьЧек(Смена, Транзакция.НомерЧека);
	
	Если ТекущийЧек = Неопределено Тогда
		ТекстОшибки = НСтр("ru='Неверный формат файла. Невозможно найти чек №%1%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1%", Формат(Транзакция.НомерЧека, "ЧГ=0"));
		Результат = Ложь;
	Иначе
		ТекущийЧек.Закрыт = Истина;
		ТекущийЧек.ДатаЧека = Транзакция.ДатаИВремя;
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ДобавитьШтрихкодМарки(Смена, Транзакция, ТекстОшибки)
	
	Результат = Истина;
	
	ТекущийЧек = ПолучитьЧек(Смена, Транзакция.НомерЧека);	
	
	Если ТекущийЧек = Неопределено Тогда
		ТекстОшибки = НСтр("ru='Неверный формат файла. Невозможно найти чек №%1%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1%", Формат(Транзакция.НомерЧека, "ЧГ=0"));
		Результат = Ложь;
	Иначе
		
		Если ТекущийЧек.Товары.Количество()>0 Тогда
			ПоследнийТовар = ТекущийЧек.Товары[ТекущийЧек.Товары.Количество()-1];
			ПоследнийТовар.ШтрихкодАлкогольнойПродукции = Транзакция.Поле8;
		Иначе
			ТекстОшибки = НСтр("ru='Неверный формат файла. Невозможно найти чек №%1%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1%", Формат(Транзакция.НомерЧека, "ЧГ=0"));
			Результат = Ложь;
		КонецЕсли;
		
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ВозвратПоНомеруЧека(Смена, Смены, Транзакция, ТекстОшибки)
	
	Результат = Истина;
	
	Если Смена=Неопределено ИЛИ ЗначениеЗаполнено(Смена.ДатаЗакрытия) Тогда
		ОткрытьСмену(Смена, Смены, Транзакция);
	КонецЕсли;
	
	ТекущийЧек = ПолучитьЧек(Смена, Транзакция.НомерЧека);
	
	Если ТекущийЧек=Неопределено Тогда
		ОткрытьЧек(Смена, Смены, Транзакция);
		ТекущийЧек = Смена.Чеки[Смена.Чеки.Количество()-1];
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция УдалитьЧек(Смена, Транзакция, ТекстОшибки)
	
	Результат = Истина;
	
	ТекущийЧек = ПолучитьЧек(Смена, Транзакция.НомерЧека);
	
	Если ТекущийЧек<>Неопределено Тогда
		Смена.Чеки.Удалить(Смена.Чеки.Найти(ТекущийЧек));
	Иначе
		ТекстОшибки = НСтр("ru='Операция прервана. Ошибка при загрузке транзакции №%1%.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1%", Формат(Транзакция.Номер, "ЧГ=0"));
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ДобавитьСкидкуНаЧек(Смена, Транзакция, ТекстОшибки)
	
	Результат = Истина;
	
	ТекущийЧек = ПолучитьЧек(Смена, Транзакция.НомерЧека);
	
	Если ТекущийЧек=Неопределено Тогда
		Результат = Ложь;
	Иначе
		
		Знак = ?(Транзакция.Тип = 35 ИЛИ Транзакция.Тип = 37, -1, 1);
		
		Если Транзакция.Тип = 35 ИЛИ Транзакция.Тип = 36 Тогда
			// Абсолютная скидка/надбавка.
			
			СуммаСкидки = Транзакция.Поле12;
			
			СуммаТоваров = 0;
			// Определяем общую сумму по товарам.
			Для Каждого ТекТовар Из ТекущийЧек.Товары Цикл
				СуммаТоваров = СуммаТоваров + ТекТовар.Сумма;
			КонецЦикла;
			
			Если СуммаТоваров>0 Тогда
				
				Для Каждого ТекТовар Из ТекущийЧек.Товары Цикл
					ТекТовар.Сумма = ТекТовар.Сумма + Знак*СуммаСкидки*(ТекТовар.Сумма/СуммаТоваров);
				КонецЦикла;
				
			КонецЕсли;
			
		Иначе
			// Относительная скидка/надбавка.
			
			СуммаЧекаСоСкидкойРасчетная = 0;
			СуммаЧекаДоСкидокНаЧек = 0;
			
			Для Каждого ТекТовар Из ТекущийЧек.Товары Цикл
				
				СуммаЧекаДоСкидокНаЧек = СуммаЧекаДоСкидокНаЧек + ТекТовар.Сумма;
				
				ТекТовар.Сумма = ТекТовар.Сумма + Знак*ТекТовар.Сумма*Транзакция.Поле11/100;
				
				СуммаЧекаСоСкидкойРасчетная = СуммаЧекаСоСкидкойРасчетная + ТекТовар.Сумма;
				
			КонецЦикла;
			
			// Если есть погрешность - учитывается в последней позиции чека
			Если НЕ (СуммаЧекаСоСкидкойРасчетная = СуммаЧекаДоСкидокНаЧек - Транзакция.Поле12) Тогда
				ПогрешностьСкидкиНаЧек = СуммаЧекаСоСкидкойРасчетная - (СуммаЧекаДоСкидокНаЧек - Транзакция.Поле12);
				
				СтрокаТоваров = ТекущийЧек.Товары[ТекущийЧек.Товары.Количество()-1];
				СтрокаТоваров.Сумма = СтрокаТоваров.Сумма - ПогрешностьСкидкиНаЧек;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Результат Тогда
		ТекстОшибки = НСтр("ru='Операция прервана. Ошибка при загрузке транзакции №%1%.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1%", Формат(Транзакция.Номер, "ЧГ=0"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция УдалитьТранзакциюИзЧека(Смена, Транзакция, ТекстОшибки)
	
	Результат = Истина;
	
	ТекущийЧек = ПолучитьЧек(Смена, Транзакция.НомерЧека);
	
	Если ТекущийЧек=Неопределено ИЛИ ТекущийЧек.Товары.Количество()=0 Тогда
		Результат = Ложь;
	Иначе
		
		СторнируемаяТранзакция = Неопределено;
		
		Для Каждого ТекТовар Из ТекущийЧек.Товары Цикл
			
			Если ТекТовар.Код = Транзакция.Поле8 И ТекТовар.Количество = -1*Транзакция.Поле11 И ТекТовар.Цена = Транзакция.Поле10 Тогда
				СторнируемаяТранзакция = ТекТовар;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если СторнируемаяТранзакция<>Неопределено Тогда
			ТекущийЧек.Товары.Удалить(ТекущийЧек.Товары.Найти(СторнируемаяТранзакция));
		Иначе
			Результат = Ложь;
		КонецЕсли;
		
		Если НЕ Результат Тогда
			ТекстОшибки = НСтр("ru='Операция прервана. Ошибка при загрузке транзакции №%1%.'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1%", Формат(Транзакция.Номер, "ЧГ=0"));
		КонецЕсли;
		
		Возврат Результат;
		
	КонецЕсли;
	
КонецФункции

Функция ДобавитьСкидкуНаТовар(Смена, Транзакция, ТекстОшибки)
	
	Результат = Истина;
	
	ТекущийЧек = ПолучитьЧек(Смена, Транзакция.НомерЧека);
	
	Если ТекущийЧек=Неопределено Тогда
		Результат = Ложь;
	Иначе
		
		НайденныеТовары = НайтиСтроки(ТекущийЧек.Товары, Новый Структура("Код", Транзакция.Поле8));
		
		Если НайденныеТовары.Количество()>0 Тогда
			
			Знак = ?(Транзакция.Тип = 15 ИЛИ Транзакция.Тип = 17, -1, 1);
			
			Товар = НайденныеТовары[НайденныеТовары.Количество()-1];
			
			Товар.Сумма = Товар.Сумма + Знак*Транзакция.Поле12;
			
		Иначе
			Результат = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Результат Тогда
		ТекстОшибки = НСтр("ru='Операция прервана. Ошибка при загрузке транзакции №%1%.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1%", Формат(Транзакция.Номер, "ЧГ=0"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЗаполнитьТранзакцию(Строка, Транзакция, ТекстОшибки)
	
	Результат = Истина;
	
	Попытка
		
		ПолеОшибки = НСтр("ru='Номер транзакции (1)'");
		
		// Номер транзакции.
		Транзакция.Вставить("Номер", Число(СтрПолучитьСтроку(Строка, 1)));
		
		ПолеОшибки = НСтр("ru='Дата и время транзакции (2,3)'");
		
		ДатаТранзакции = СтрЗаменить(СтрПолучитьСтроку(Строка, 2), ".", Символы.ПС);
		ВремяТранзакции = СтрЗаменить(СтрПолучитьСтроку(Строка, 3), ":", Символы.ПС);
		
		Год = Число(СтрПолучитьСтроку(ДатаТранзакции, 3));
		Если Год < 100 Тогда
			Год = 2000 + Год;
		КонецЕсли;
		
		// Дата и время транзакции.
		Транзакция.Вставить("ДатаИВремя",
			Дата(Год,
				Число(СтрПолучитьСтроку(ДатаТранзакции, 2)),
				Число(СтрПолучитьСтроку(ДатаТранзакции, 1)),
				Число(СтрПолучитьСтроку(ВремяТранзакции, 1)),
				Число(СтрПолучитьСтроку(ВремяТранзакции, 2)),
				Число(СтрПолучитьСтроку(ВремяТранзакции, 3))
			)
		);
		
		ПолеОшибки = НСтр("ru='Тип транзакции (4)'");
		
		// Тип транзакции.
		Транзакция.Вставить("Тип", Число(СтрПолучитьСтроку(Строка, 4)));
		
		ПолеОшибки = НСтр("ru='Номер чека (6)'");
		
		// Номер чека транзакции.
		Транзакция.Вставить("НомерЧека", Число(СтрПолучитьСтроку(Строка, 6)));
		
		ПолеОшибки = НСтр("ru='Поле №8 (8)'");
		
		// Поле №8.
		Транзакция.Вставить("Поле8", СтрПолучитьСтроку(Строка, 8));
		
		ПолеОшибки = НСтр("ru='Поле №9 (9)'");
		
		// Поле №9.
		Транзакция.Вставить("Поле9", Число(СтрПолучитьСтроку(Строка, 9)));
		
		ПолеОшибки = НСтр("ru='Поле №10 (10)'");
		
		// Поле №10.
		Транзакция.Вставить("Поле10", Число(СтрПолучитьСтроку(Строка, 10)));
		
		ПолеОшибки = НСтр("ru='Поле №11 (11)'");
		
		// Поле №11.
		Транзакция.Вставить("Поле11", Число(СтрПолучитьСтроку(Строка, 11)));
		
		ПолеОшибки = НСтр("ru='Поле №12 (12)'");
		
		// Поле №12.
		Транзакция.Вставить("Поле12", Число(СтрПолучитьСтроку(Строка, 12)));
		
	Исключение
		
		// Если в процессе разбора транзакции произошла ошибка.
		ТекстОшибки = НСтр("ru='Неверный формат файла. Невозможно распознать поле: %1%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1%", ПолеОшибки);
		
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
