﻿#Область СлужебныйПрограммныйИнтерфейс

// Возвращает ссылки на узлы с очередью меньшей, чем переданная.
//
// Параметры:
//  Очередь	 - Число - очередь обработки данных.
// 
// Возвращаемое значение:
// 	Массив - массив со значениями:
//		* ПланОбменаСсылка.ОбновлениеИнформационнойБазы 
//
Функция УзлыМеньшейОчереди(Очередь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбновлениеИнформационнойБазы.Ссылка КАК Ссылка
	|ИЗ
	|	ПланОбмена.ОбновлениеИнформационнойБазы КАК ОбновлениеИнформационнойБазы
	|ГДЕ
	|	ОбновлениеИнформационнойБазы.Очередь < &Очередь
	|	И НЕ ОбновлениеИнформационнойБазы.ЭтотУзел
	|	И ОбновлениеИнформационнойБазы.Очередь <> 0";
	
	Запрос.УстановитьПараметр("Очередь", Очередь);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Ищет узел плана обмена по очереди и возвращает ссылку на него.
// Если узла еще нет, то он будет создан.
//
// Параметры:
//  Очередь	 - Число - очередь обработки данных.
// 
// Возвращаемое значение:
// 	ПланОбменаСсылка.ОбновлениеИнформационнойБазы.
//
Функция УзелПоОчереди(Очередь) Экспорт
	
	Если ТипЗнч(Очередь) <> Тип("Число")  
		Или Очередь = 0 Тогда
		ТекстИсключения = НСтр("ru = 'Не возможно получить узел плана обмена ОбновлениеИнформационнойБазы, т.к. не передан номер очереди.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Блокировка.Добавить("ПланОбмена.ОбновлениеИнформационнойБазы");
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ОбновлениеИнформационнойБазы.Ссылка КАК Ссылка
		|ИЗ
		|	ПланОбмена.ОбновлениеИнформационнойБазы КАК ОбновлениеИнформационнойБазы
		|ГДЕ
		|	ОбновлениеИнформационнойБазы.Очередь = &Очередь
		|	И НЕ ОбновлениеИнформационнойБазы.ЭтотУзел";
		
		Запрос.УстановитьПараметр("Очередь", Очередь);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Узел = Выборка.Ссылка;
		Иначе
			УзелОбъект = СоздатьУзел();
			УзелОбъект.Очередь = Очередь;
			УзелОбъект.УстановитьНовыйКод(Строка(Очередь));
			УзелОбъект.Наименование = Строка(Очередь);
			УзелОбъект.Записать();
			Узел = УзелОбъект.Ссылка;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Узел;
КонецФункции

#КонецОбласти