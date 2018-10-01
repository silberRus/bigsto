﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивПериодов = Параметры.МассивЗначений;
	УникальныйИдентификаторСтроки = Параметры.УникальныйИдентификаторСтроки;
	СоответствияДатаМесяц = ИнициализацияСоответствияДатаМесяц();
	
	Для Каждого ЭлементМассива Из МассивПериодов Цикл
		Если СоответствияДатаМесяц.Получить(ЭлементМассива) = Неопределено Тогда
			ПроизвольнаяДата = ЭлементМассива;
		Иначе
			ЭтаФорма[СоответствияДатаМесяц.Получить(ЭлементМассива)] = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДоступностьГруппаБолкВыбораМесяца();
	ДоступностьГруппаПроизвольнаяДата();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ПараметрыОповещения = Новый Структура;
	МассивЗначений = Новый Массив;
	СоответствияМесяцДата = ИнициализацияСоответствияМесяцДата();
	Если ЗначениеЗаполнено(ПроизвольнаяДата) Тогда
		МассивЗначений.Добавить(ПроизвольнаяДата);
	КонецЕсли;
	Для Каждого ЭлементФормы Из Элементы.ГруппаМесяца.ПодчиненныеЭлементы Цикл
		Если ЭтаФорма[ЭлементФормы.Имя] Тогда
			МассивЗначений.Добавить(СоответствияМесяцДата.Получить(ЭлементФормы.Имя));
		КонецЕсли;
	КонецЦикла;
	ПараметрыОповещения.Вставить("МассивЗначений", МассивЗначений);
	ПараметрыОповещения.Вставить("УникальныйИдентификаторСтроки", УникальныйИдентификаторСтроки);
	ИмяСобытия = "ПериодПотребности";
	ФормаИсточник = "РегистрСведений.ПотребностьКлиентов.Форма.РегистрацияПотребностиСпроса";
	Оповестить(ИмяСобытия, ПараметрыОповещения, ФормаИсточник);
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыделитьВсеПриИзменении(Элемент)
	Для Каждого ЭлементФормы Из Элементы.ГруппаМесяца.ПодчиненныеЭлементы Цикл
		ЭтаФорма[ЭлементФормы.Имя] = ВыделитьВсе;
	КонецЦикла;
	ДоступностьГруппаПроизвольнаяДата();
КонецПроцедуры

&НаКлиенте
Процедура ПроизвольнаяДатаПриИзменении(Элемент)
	ДоступностьГруппаБолкВыбораМесяца();
КонецПроцедуры

&НаКлиенте
Процедура МесяцПриИзменении(Элемент)
	ДоступностьГруппаПроизвольнаяДата();
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы
//Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДоступностьГруппаБолкВыбораМесяца()
	Элементы.ГруппаБолкВыбораМесяца.Доступность = НЕ ЗначениеЗаполнено(ПроизвольнаяДата);
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьГруппаПроизвольнаяДата()
	
	ДоступностьГруппы = Истина;
	
	Для Каждого ЭлементФормы Из Элементы.ГруппаМесяца.ПодчиненныеЭлементы Цикл
		Если ЭтаФорма[ЭлементФормы.Имя] Тогда
			ДоступностьГруппы = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ГруппаПроизвольнаяДата.Доступность = ДоступностьГруппы;
	
КонецПроцедуры

&НаКлиенте
Функция ИнициализацияСоответствияМесяцДата()
	
	Результат = Новый Соответствие;
	Результат.Вставить("Январь", Дата(2,1,1));
	Результат.Вставить("Февраль", Дата(2,2,1));
	Результат.Вставить("Март", Дата(2,3,1));
	Результат.Вставить("Апрель", Дата(2,4,1));
	Результат.Вставить("Май", Дата(2,5,1));
	Результат.Вставить("Июнь", Дата(2,6,1));
	Результат.Вставить("Июль", Дата(2,7,1));
	Результат.Вставить("Август", Дата(2,8,1));
	Результат.Вставить("Сентябрь", Дата(2,9,1));
	Результат.Вставить("Октябрь", Дата(2,10,1));
	Результат.Вставить("Ноябрь", Дата(2,11,1));
	Результат.Вставить("Декабрь", Дата(2,12,1));
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ИнициализацияСоответствияДатаМесяц()
	
	Результат = Новый Соответствие;
	Результат.Вставить(Дата(2,1,1), "Январь");
	Результат.Вставить(Дата(2,2,1), "Февраль");
	Результат.Вставить(Дата(2,3,1), "Март");
	Результат.Вставить(Дата(2,4,1), "Апрель");
	Результат.Вставить(Дата(2,5,1), "Май");
	Результат.Вставить(Дата(2,6,1), "Июнь");
	Результат.Вставить(Дата(2,7,1), "Июль");
	Результат.Вставить(Дата(2,8,1), "Август");
	Результат.Вставить(Дата(2,9,1), "Сентябрь");
	Результат.Вставить(Дата(2,10,1), "Октябрь");
	Результат.Вставить(Дата(2,11,1), "Ноябрь");
	Результат.Вставить(Дата(2,12,1), "Декабрь");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти



















