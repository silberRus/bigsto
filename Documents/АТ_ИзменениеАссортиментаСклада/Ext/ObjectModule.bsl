﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АТ_ОбеспечениеРегиональныхСкладовСрезПоследних.Номенклатура КАК Номенклатура,
	|	АТ_ОбеспечениеРегиональныхСкладовСрезПоследних.Мин КАК Мин,
	|	АТ_ОбеспечениеРегиональныхСкладовСрезПоследних.Макс КАК Макс
	|ИЗ
	|	РегистрСведений.АТ_ОбеспечениеРегиональныхСкладов.СрезПоследних КАК АТ_ОбеспечениеРегиональныхСкладовСрезПоследних
	|ГДЕ
	|	АТ_ОбеспечениеРегиональныхСкладовСрезПоследних.Макс > 0
	|	И АТ_ОбеспечениеРегиональныхСкладовСрезПоследних.Склад = &Склад";
	Запрос.УстановитьПараметр("Склад", Склад);
	Выгрузка = Запрос.Выполнить().Выгрузить();
	Выгрузка.Индексы.Добавить("Номенклатура");
	
	
	Движения.АТ_ОбеспечениеРегиональныхСкладов.Записывать = Истина;
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.АТ_ОбеспечениеРегиональныхСкладов.Добавить();
		Движение.Период = Дата;
		Движение.Склад = Склад;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Мин = ТекСтрокаТовары.Мин;
		Движение.Макс = ТекСтрокаТовары.Макс;
		Если Не ЗначениеЗаполнено(ЗаказНаПеремещение) И Не Выгрузка.Количество() = 0 И Выгрузка.Найти(ТекСтрокаТовары.Номенклатура, "Номенклатура") = Неопределено Тогда
			Движение.Новый = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ГрупповоеПерепроведение") И ДополнительныеСвойства.ГрупповоеПерепроведение Тогда
		Возврат;
	КонецЕсли;
	
	Ответственный = ПараметрыСеанса.ТекущийПользователь;
	
КонецПроцедуры


