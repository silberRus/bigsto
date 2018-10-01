﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов") Тогда
		ЗаполнитьДокументНаОснованииПриобретениеУслугПрочихАктивов(ДанныеЗаполнения);
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		ЗаполнитьДокументНаОснованииАвансовыйОтчет(ДанныеЗаполнения);
		
	Иначе
		ЗаполнитьРеквизитыПоУмолчанию();
	КонецЕсли;
	
	ЗаполнитьЗависимыеОтКонтрагентаРеквизиты();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ЗаписьКнигиПокупок.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДоходыИРасходыСервер.ОтразитьНДСЗаписиКнигиПокупок(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьЖурналУчетаСчетовФактур(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ ЗаписьДополнительногоЛиста Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КорректируемыйПериод");
	КонецЕсли; 
	
	Если НЕ ПредъявленСчетФактура Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерСчетаФактуры");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаСчетаФактуры");
	КонецЕсли; 
	
	Если НЕ ПредъявленСчетФактура Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КодВидаОперации");
	КонецЕсли; 
	
	Если СпособКорректировкиНДС = Перечисления.СпособыКорректировкиНДС.Отложить
		ИЛИ СпособКорректировкиНДС = Перечисления.СпособыКорректировкиНДС.Заблокировать Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Ценности.ВидЦенности");
		МассивНепроверяемыхРеквизитов.Добавить("Ценности.Событие");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Ценности.Номенклатура");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	УчетНДСУТ.ПроверитьСовместимостьВидовЦенностейТабличнойЧасти(ЭтотОбъект, "Ценности", Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СуммаДокумента = Ценности.Итог("Сумма") + Ценности.Итог("СуммаНДС");
	
	Если НЕ ЗначениеЗаполнено(ДокументРасчетов) И ДокументРасчетов <> Неопределено Тогда
		ДокументРасчетов = Неопределено
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Ценности);
	КонецЕсли;
	
	Если НЕ ЗаписьДополнительногоЛиста И ЗначениеЗаполнено(КорректируемыйПериод) Тогда
		КорректируемыйПериод = '00010101'
	КонецЕсли;
	
КонецПроцедуры

#Область ЗаполнениеДокумента

Процедура ЗаполнитьРеквизитыПоУмолчанию()

	Ответственный	= Пользователи.ТекущийПользователь();
	Организация		= ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта			= ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПриобретениеУслугПрочихАктивов(Знач Основание)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПриобретениеУслугПрочихАктивов.Организация    КАК Организация,
		|	ПриобретениеУслугПрочихАктивов.Контрагент     КАК Контрагент,
		|	ПриобретениеУслугПрочихАктивов.Валюта         КАК Валюта,
		|	ПриобретениеУслугПрочихАктивов.СуммаДокумента КАК СуммаДокумента,
		|	ПриобретениеУслугПрочихАктивов.Подразделение  КАК Подразделение,
		|	""23"" КАК КодВидаОперации // 23 Командировочные расходы по бланку строгой отчетности, п.7 статьи 171 НК
		|ИЗ
		|	Документ.ПриобретениеУслугПрочихАктивов КАК ПриобретениеУслугПрочихАктивов
		|ГДЕ
		|	ПриобретениеУслугПрочихАктивов.Ссылка = &Основание
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.ПрочиеРаботыИУслуги)        КАК ВидЦенности,
		|	ЗНАЧЕНИЕ(Перечисление.СобытияПоНДСПокупки.ПредъявленНДСКВычету) КАК Событие,
		|	ПриобретениеУслугПрочихАктивовРасходы.СтавкаНДС                  КАК СтавкаНДС,
		|	СУММА(ПриобретениеУслугПрочихАктивовРасходы.СуммаНДС)            КАК СуммаНДС,
		|	СУММА(ПриобретениеУслугПрочихАктивовРасходы.СуммаСНДС)           КАК Сумма
		|ИЗ
		|	Документ.ПриобретениеУслугПрочихАктивов.Расходы КАК ПриобретениеУслугПрочихАктивовРасходы
		|ГДЕ
		|	ПриобретениеУслугПрочихАктивовРасходы.Ссылка = &Основание
		|
		|СГРУППИРОВАТЬ ПО
		|	ПриобретениеУслугПрочихАктивовРасходы.СтавкаНДС");
		
	Запрос.УстановитьПараметр("Основание", Основание);
	
	Результат = Запрос.ВыполнитьПакет();
	ШапкаОснование = Результат[0].Выбрать();
	ШапкаОснование.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ШапкаОснование);
	
	ТабличнаяЧастьОснование = Результат[1];
	ЭтотОбъект.Ценности.Загрузить(ТабличнаяЧастьОснование.Выгрузить());
	
	ЭтотОбъект.ДокументРасчетов = Основание;
	ЭтотОбъект.ДокументОснование = Основание;
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииАвансовыйОтчет(Знач Основание)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка         КАК ДокументОснование,
		|	ДанныеДокумента.Ссылка         КАК ДокументОплаты,
		|	ДанныеДокумента.Дата           КАК ДатаОплаты,
		|	ДанныеДокумента.Организация    КАК Организация,
		|	ДанныеДокумента.Валюта         КАК Валюта,
		|	ДанныеДокумента.Подразделение  КАК Подразделение,
		|	""23"" КАК КодВидаОперации // 23 Командировочные расходы по бланку строгой отчетности, п.7 статьи 171 НК
		|ИЗ
		|	Документ.АвансовыйОтчет КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &Основание
		|	И НЕ ДанныеДокумента.Мультивалютный
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка         КАК ДокументОснование,
		|	ДанныеДокумента.Ссылка         КАК ДокументОплаты,
		|	ДанныеДокумента.Дата           КАК ДатаОплаты,
		|	ДанныеДокумента.Организация    КАК Организация,
		|	Расходы.Валюта                 КАК Валюта,
		|	ДанныеДокумента.Подразделение  КАК Подразделение,
		|	""23"" КАК КодВидаОперации // 23 Командировочные расходы по бланку строгой отчетности, п.7 статьи 171 НК
		|ИЗ
		|	Документ.АвансовыйОтчет КАК ДанныеДокумента
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		(ВЫБРАТЬ
		|				Расходы.Ссылка,
		|				МАКСИМУМ(Расходы.Валюта) КАК Валюта
		|			ИЗ
		|				Документ.АвансовыйОтчет.ПрочиеРасходы КАК Расходы
		|			ГДЕ
		|				Расходы.Ссылка = &Основание
		|			СГРУППИРОВАТЬ ПО
		|				Расходы.Ссылка
		|			ИМЕЮЩИЕ
		|				КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Расходы.Валюта) = 1
		|		) КАК Расходы
		|	ПО
		|		Расходы.Ссылка = ДанныеДокумента.Ссылка
		|	
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &Основание
		|	И ДанныеДокумента.Мультивалютный
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	МАКСИМУМ(Расходы.Контрагент) КАК Контрагент
		|	
		|ИЗ
		|	Документ.АвансовыйОтчет.ПрочиеРасходы КАК Расходы
		|ГДЕ
		|	Расходы.Ссылка = &Основание
		|	И Расходы.СтавкаНДС <> ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
		|	И НЕ Расходы.Отменено
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Расходы.Контрагент) = 1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.ПрочиеРаботыИУслуги)        КАК ВидЦенности,
		|	ЗНАЧЕНИЕ(Перечисление.СобытияПоНДСПокупки.ПредъявленНДСКВычету) КАК Событие,
		|	Расходы.СтавкаНДС                  КАК СтавкаНДС,
		|	СУММА(Расходы.СуммаНДС)            КАК СуммаНДС,
		|	СУММА(Расходы.Сумма) - СУММА(Расходы.СуммаНДС) КАК Сумма
		|	
		|ИЗ
		|	Документ.АвансовыйОтчет.ПрочиеРасходы КАК Расходы
		|ГДЕ
		|	Расходы.Ссылка = &Основание
		|	И Расходы.СтавкаНДС <> ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
		|	И НЕ Расходы.Отменено
		|	И НЕ Расходы.Ссылка.Мультивалютный
		|
		|СГРУППИРОВАТЬ ПО
		|	Расходы.СтавкаНДС,
		|	Расходы.Контрагент
		|");
		
	Запрос.УстановитьПараметр("Основание", Основание);
	
	Результат = Запрос.ВыполнитьПакет();
	РеквизитыОснования = Результат[0].Выбрать();
	РеквизитыОснования.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыОснования);
	
	СтрокаДокументыОплаты = ЭтотОбъект.ДокументыОплаты.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаДокументыОплаты, РеквизитыОснования);
	
	Если Не Результат[1].Пустой() Тогда
		
		Выборка = Результат[1].Выбрать();
		Выборка.Следующий();
		ЭтотОбъект.Контрагент = Выборка.Контрагент;
		
		ЭтотОбъект.Ценности.Загрузить(Результат[2].Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

Процедура 	ЗаполнитьЗависимыеОтКонтрагентаРеквизиты()
	
	Если ЗначениеЗаполнено(Контрагент)
		И ТипЗнч(Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		РеквизитыКонтрагента = Справочники.Контрагенты.РеквизитыКонтрагента(Контрагент, Дата);
		ИННКонтрагента = РеквизитыКонтрагента.ИНН;
		КППКонтрагента = РеквизитыКонтрагента.КПП;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
