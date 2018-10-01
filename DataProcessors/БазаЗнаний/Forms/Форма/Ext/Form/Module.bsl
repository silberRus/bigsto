﻿////////////////////////////////////////////////////////////////////////////////
// УПРАВЛЕНИЕ ФОРМОЙ

&НаКлиенте
Процедура УстановитьДоступность()
	
	КолСтрокИстории = Объект.История.Количество();
	
	КнопкаНазад 	= (КолСтрокИстории > 1 И ТекущаяСтраница > 1);
	КнопкаВперед	= (КолСтрокИстории > 1 И ТекущаяСтраница < КолСтрокИстории);
	
	Элементы.ФормаСтраницаНазад.Доступность		= КнопкаНазад;
	Элементы.КонтекстноеМенюНазад.Доступность	= КнопкаНазад;
	Элементы.ФормаСтраницаВперед.Доступность	= КнопкаВперед;
	Элементы.ФормаСтраницаВперед.Доступность	= КнопкаВперед;
	
	Элементы.ФормаПоиск.Пометка = Элементы.ГруппаПоиск.Видимость;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Основная страница

&НаКлиенте
Процедура ДокументHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ДанныеСобытия.Anchor = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрСсылки = ДанныеСобытия.Href;
	
	Если Лев(ПараметрСсылки, 7) = "mailto:" Тогда
		НавигационнаяСсылка_mailto(ПараметрСсылки);
	ИначеЕсли Лев(ПараметрСсылки, 9) = "kb://api/" Тогда
		НавигационнаяСсылка_kbapi(ПараметрСсылки);
	ИначеЕсли Лев(ПараметрСсылки, 5) = "file:" Тогда
		НавигационнаяСсылка_file(ПараметрСсылки);
	ИначеЕсли Лев(ПараметрСсылки, 4) = "http" Тогда
		ОткрытьВнешнююСсылку(ПараметрСсылки);
	ИначеЕсли Лев(ПараметрСсылки, 6) = "e1c://" Тогда
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ссылки внутри документа не обрабатываются. Приносим извинения за причиненные неудобства.");
	Иначе
		Сообщить(ПараметрСсылки);
	КонецЕсли;
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументHTMLДокументСформирован(Элемент)
	Если НЕ ПустаяСтрока(Объект.Область) Тогда
		ПерейтиНаОбластьСтраницы(Объект.Область);
		
		Объект.СтатьяБазыЗнаний = Неопределено;
		Объект.Область			= "";
	КонецЕсли;
	
	Попытка
		ИмяСайта = Элементы.ДокументHTML.Документ.nameProp;
	Исключение
		ИмяСайта = ЭтотОбъект.Заголовок;
	КонецПопытки;
	
	Если НЕ ПустаяСтрока(ИмяСайта) И НЕ ИмяСайта = ЭтотОбъект.Заголовок Тогда
		ЭтотОбъект.АвтоЗаголовок	= Ложь;
		ЭтотОбъект.Заголовок		= ИмяСайта;
		
		Если ТекущаяСтраница > 0 И ТекущаяСтраница <= Объект.История.Количество() Тогда
			Объект.История[ТекущаяСтраница-1].Представление = ИмяСайта;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДокументHTMLПриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры

// Поиск

&НаКлиенте
Процедура СтрокаПоискаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаПоиска = Текст;
	
	ВыполнитьПоиск(0);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПоискаHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Лев(ДанныеСобытия.Href, 9) = "kb://api/" Тогда
		НавигационнаяСсылка_kbapi(ДанныеСобытия.Href, Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//АдресWikiСтраницы = БазаЗнанийКлиентСерверПовтИсп.ПолучитьЗначениеОбщейНастройки("АдресMediaWiki");
	//Элементы.ФормаПерейтиНаСтраницуWiki.Доступность = ЗначениеЗаполнено(АдресWikiСтраницы);
	
	Объект.СтатьяБазыЗнаний = Параметры.СтатьяБазыЗнаний;
	Объект.Область			= Параметры.Область;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	КлючСессии = БазаЗнаний.НачатьСессиюПользователя(ТекущийПользователь);
	
	Элементы.ФормаПрофильПользователя.Заголовок = Строка(ТекущийПользователь);
	
	Если ЗначениеЗаполнено(Объект.СтатьяБазыЗнаний) Тогда
		ПараметрыСсылки	= Новый Структура;
		ПараметрыСсылки.Вставить("id", Строка(Объект.СтатьяБазыЗнаний.УникальныйИдентификатор()));
		Если НЕ ПустаяСтрока(ПараметрыСсылки) Тогда
			ПараметрыСсылки.Вставить("section", Объект.Область);
		КонецЕсли;
		
		АдресСтраницы	= КонструкторСсылки_page("article", ПараметрыСсылки);
	Иначе 
		АдресСтраницы	= КонструкторСсылки_page("home", Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Результат = ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	Если НЕ Результат = "Подключено" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаПоиск.Видимость = Ложь;
	
	УстановитьДоступность();
	
	Если ЗначениеЗаполнено(АдресСтраницы) Тогда
		ПараметрыВывода = Новый Структура("Обновление", Истина);
		ПерейтиНаСтраницу(АдресСтраницы, ПараметрыВывода);
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбработатьОповещенияПользователя", 5, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	//ОбновитьСтраницу(Неопределено);
	//
	//Если ТипЗнч(НовыйОбъект) = Тип("СправочникСсылка.КомментарииБазыЗнаний") Тогда
	//	Идентификатор	= НовыйОбъект.УникальныйИдентификатор();
	//	ОбластьПерехода	= "comment_" + Строка(Идентификатор);
	//	ПерейтиНаОбластьСтраницы(ОбластьПерехода);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ПриЗакрытииНаСервере();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА КОМАНД ФОРМЫ

&НаКлиенте
Процедура ИнформацияОСистеме(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура Поиск(Команда)
	Элементы.ГруппаПоиск.Видимость = НЕ Элементы.ГруппаПоиск.Видимость;
	
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ГлавнаяСтраница(Команда)
	
	АдресСтраницы	= КонструкторСсылки_page("home", Неопределено);
	НавигационнаяСсылка_kbapi(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаВперед(Команда)
	
	НоваяСтраница = ТекущаяСтраница + 1;
	
	Если НоваяСтраница >= 1 И НоваяСтраница <= Объект.История.Количество() Тогда
		ЭтотОбъект.ДокументHTML = Объект.История[НоваяСтраница-1].ТекстСтраницы;
		
		ТекущаяСтраница = НоваяСтраница;
	КонецЕсли;
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаНазад(Команда)
	
	НоваяСтраница = ТекущаяСтраница - 1;
	
	Если НоваяСтраница >= 1 И НоваяСтраница <= Объект.История.Количество() Тогда
		ЭтотОбъект.ДокументHTML		= Объект.История[НоваяСтраница-1].ТекстСтраницы;
		
		ТекущаяСтраница = НоваяСтраница;
	КонецЕсли;
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтраницу(Команда)
	
	АдресСтраницы = ПолучитьТекущийАдресСсылки(Объект.История, ТекущаяСтраница);
	
	ПараметрыСтраницы = Новый Структура;
	ПараметрыСтраницы.Вставить("Обновление", Истина);
	
	ПерейтиНаСтраницу(АдресСтраницы, ПараметрыСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	МестоСохранения = ВыбратьМестоСохранения(Истина);
	Если МестоСохранения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСсылка	= ПолучитьТекущуюСсылку(Объект.История, ТекущаяСтраница);
	ИмяФайла		= ЭтотОбъект.Заголовок;
	ИмяФайла		= ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла);
	ПутьКФайлу		= МестоСохранения + "\" + ИмяФайла + ".html";
	
	ТекстСтраницы = ЭтотОбъект.ДокументHTML;
	
	ЗаписьТекста = Новый ЗаписьТекста;
	ЗаписьТекста.Открыть(ПутьКФайлу);
	ЗаписьТекста.Записать(ТекстСтраницы);
	ЗаписьТекста.Закрыть();
	
	ЗапуститьПриложение(ПутьКФайлу);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьСКартинками(Команда)
	
	МестоСохранения = ВыбратьМестоСохранения(Истина);
	Если МестоСохранения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МестоСохранения = МестоСохранения + "\";
	АдресаКартинок	= Новый Соответствие;
	
	ТекстСтраницы = ЭтотОбъект.ДокументHTML;
	
	КаталогФайлов	= БазаЗнанийКлиентСерверПовтИсп.КаталогФайлов();
	
	КопияСтроки		= ТекстСтраницы;
	ОстатокСтроки	= ТекстСтраницы;
	Позиция			= Найти(ОстатокСтроки, "img src='" + КаталогФайлов);
	Пока Позиция > 0 Цикл
		СтрокаДокумента = Сред(ОстатокСтроки, Позиция + 9);
		КонецИмени		= Найти(СтрокаДокумента, "'");
		АдресФайла		= Сред(СтрокаДокумента, 1, КонецИмени - 1);
		НовыйАдрес		= СтрЗаменить(АдресФайла, КаталогФайлов, МестоСохранения);
		
		КопироватьФайл(АдресФайла, НовыйАдрес);
		
		АдресаКартинок.Вставить(АдресФайла, НовыйАдрес);
		
		ОстатокСтроки	= Сред(СтрокаДокумента, КонецИмени + 1);
		Позиция			= Найти(ОстатокСтроки, "img src='");
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из АдресаКартинок Цикл
		АдресВДокументе	= "'" + КлючИЗначение.Ключ + "'";
		НовыйАдресФайла	= "'" + КлючИЗначение.Значение + "'";
		
		КопияСтроки = СтрЗаменить(КопияСтроки, АдресВДокументе, НовыйАдресФайла);
	КонецЦикла;
	
	ТекущаяСсылка	= ПолучитьТекущуюСсылку(Объект.История, ТекущаяСтраница);
	ИмяФайла		= ЭтотОбъект.Заголовок;
	ИмяФайла		= ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла);
	ПутьКФайлу		= МестоСохранения + ИмяФайла + ".html";
	
	ЗаписьТекста = Новый ЗаписьТекста;
	ЗаписьТекста.Открыть(ПутьКФайлу);
	ЗаписьТекста.Записать(КопияСтроки);
	ЗаписьТекста.Закрыть();
	
	ЗапуститьПриложение(ПутьКФайлу);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьОкноПоиска(Команда)
	Элементы.ГруппаПоиск.Видимость = Ложь;
	
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура СледующаяСтраницаПоиска(Команда)
	
	ВыполнитьПоиск(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущаяСтраницаПоиска(Команда)
	
	ВыполнитьПоиск(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуWiki(Команда)
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Адрес", БазаЗнанийКлиентСерверПовтИсп.ПолучитьЗначениеОбщейНастройки("АдресMediaWiki"));
	ОткрытьВнешнююСсылкуВыполнить(КодВозвратаДиалога.Нет, ДопПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ПрофильПользователя(Команда)
	
	ПараметрыСсылки	= Новый Структура;
	ПараметрыСсылки.Вставить("id", Строка(ТекущийПользователь.УникальныйИдентификатор()));
	АдресСтраницы = КонструкторСсылки_page("user", ПараметрыСсылки);
	
	ПерейтиНаСтраницу(АдресСтраницы); 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// НАВИГАЦИОННЫЕ ССЫЛКИ

&НаКлиенте
Процедура ОткрытьВнешнююСсылку(АдресСсылки)
	
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить(КодВозвратаДиалога.Да		, "Да (в браузере)");
	СписокКнопок.Добавить(КодВозвратаДиалога.Нет	, "Нет (в окне 1С)");
	СписокКнопок.Добавить(КодВозвратаДиалога.Отмена	, "Отмена (не открывать)");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьВнешнююСсылкуВыполнить", ЭтотОбъект, Новый Структура("Адрес", АдресСсылки));
	ПоказатьВопрос(ОписаниеОповещения,
		НСтр("ru='Открыть внешнюю ссылку в окне браузера по умолчанию?
		|" + АдресСсылки + "'"),
		СписокКнопок,
		,
		КодВозвратаДиалога.Отмена,
		,
		КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАдресСсылки_create(знач ДанныеСсылки)
	
	ПараметрыСсылки = ДанныеСсылки.Параметры;
	Если НЕ ПараметрыСсылки.Свойство("name") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСсылка = ПолучитьТекущуюСсылку(Объект.История, ТекущаяСтраница);
	
	Если ПараметрыСсылки.name = "category" Тогда
		ИДКомментарий		= ?(ПараметрыСсылки.Свойство("parent"), ПараметрыСсылки.parent, "");
		КомментарийСсылка	= ПолучитьСсылкуПоИдентификатору("КомментарииБазыЗнаний", ИДКомментарий);
		ЗначенияЗаполнения	= Новый Структура("Родитель", КомментарийСсылка);
		ПараметрыФормы		= Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
		ИмяФормыСсылки		= "Справочник.КатегорииБазыЗнаний.ФормаОбъекта";
		ОписаниеОповещения	= Новый ОписаниеОповещения("ПослеИзмененияДанныхКатегории", ЭтотОбъект, Новый Структура("ЭтоНовый", Истина));
	ИначеЕсли ПараметрыСсылки.name = "article" Тогда
		ИДКатегория			= ?(ПараметрыСсылки.Свойство("category"), ПараметрыСсылки.category, "");
		КатегорияСсылка		= ПолучитьСсылкуПоИдентификатору("КатегорииБазыЗнаний", ИДКатегория);
		
		ЗначенияЗаполнения	= Новый Структура;
		ЗначенияЗаполнения.Вставить("Категория", КатегорияСсылка);
		
		ПараметрыФормы		= Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ПараметрыФормы		= Неопределено;
		ИмяФормыСсылки		= "Справочник.СтатьиБазыЗнаний.Форма.РедактированиеСтатьи";
		ОписаниеОповещения	= Новый ОписаниеОповещения("ПослеИзмененияДанныхСтатьи", ЭтотОбъект, Новый Структура("ЭтоНовый", Истина));
	ИначеЕсли ПараметрыСсылки.name = "comment" Тогда
		ИДКомментарий	= ?(ПараметрыСсылки.Свойство("id"), ПараметрыСсылки.id, "");
		ИДСтатья		= ?(ПараметрыСсылки.Свойство("article"), ПараметрыСсылки.article, "");
		ИДАвтор			= ?(ПараметрыСсылки.Свойство("user"), ПараметрыСсылки.user, "");
		
		КомментарийСсылка	= ПолучитьСсылкуПоИдентификатору("КомментарииБазыЗнаний", ИДКомментарий);
		СтатьяСсылка		= ПолучитьСсылкуПоИдентификатору("СтатьиБазыЗнаний", ИДСтатья);
		ПользовательСсылка	= ПолучитьСсылкуПоИдентификатору("Пользователи", ИДАвтор);
		
		ЗначенияЗаполнения	= Новый Структура;
		ЗначенияЗаполнения.Вставить("Владелец"	, ?(ЗначениеЗаполнено(СтатьяСсылка), СтатьяСсылка, ТекущаяСсылка));
		ЗначенияЗаполнения.Вставить("Автор"		, ?(ЗначениеЗаполнено(ПользовательСсылка), ЭтотОбъект.ТекущийПользователь, ПользовательСсылка));
		
		ПараметрыФормы		= Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		ПараметрыФормы.Вставить("Родитель", КомментарийСсылка);
		
		ИмяФормыСсылки		= "Справочник.КомментарииБазыЗнаний.Форма.ФормаРедактирования";
		
		ПараметрыОповещения	= Новый Структура;
		ПараметрыОповещения.Вставить("Ссылка"	, КомментарийСсылка);
		ПараметрыОповещения.Вставить("Статья"	, ТекущаяСсылка);
		ОписаниеОповещения	= Новый ОписаниеОповещения("ПослеИзмененияДанныхКомментария", ЭтотОбъект, ПараметрыОповещения);
	Иначе 
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормыСсылки, ПараметрыФормы, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАдресСсылки_edit(знач ДанныеСсылки)
	
	ПараметрыСсылки = ДанныеСсылки.Параметры;
	Если НЕ ПараметрыСсылки.Свойство("name") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСсылка = ПолучитьТекущуюСсылку(Объект.История, ТекущаяСтраница);
	
	Если ПараметрыСсылки.name = "category" Тогда
		Идентификатор		= ?(ПараметрыСсылки.Свойство("id"), ПараметрыСсылки.id, "");
		ЭлементСсылка		= ПолучитьСсылкуПоИдентификатору("КатегорииБазыЗнаний", Идентификатор);
		ИмяФормыСсылки		= "Справочник.КатегорииБазыЗнаний.ФормаОбъекта";
		ОписаниеОповещения	= Новый ОписаниеОповещения("ПослеИзмененияДанныхКатегории", ЭтотОбъект, Новый Структура("Категория", ЭлементСсылка));
	ИначеЕсли ПараметрыСсылки.name = "article" Тогда
		Идентификатор		= ?(ПараметрыСсылки.Свойство("id"), ПараметрыСсылки.id, "");
		ЭлементСсылка		= ПолучитьСсылкуПоИдентификатору("СтатьиБазыЗнаний", Идентификатор);
		ИмяФормыСсылки		= "Справочник.СтатьиБазыЗнаний.Форма.РедактированиеСтатьи";
		ОписаниеОповещения	= Новый ОписаниеОповещения("ПослеИзмененияДанныхСтатьи", ЭтотОбъект, Новый Структура("Статья", ЭлементСсылка));
	ИначеЕсли ПараметрыСсылки.name = "comment" Тогда
		Идентификатор		= ?(ПараметрыСсылки.Свойство("id"), ПараметрыСсылки.id, "");
		ЭлементСсылка		= ПолучитьСсылкуПоИдентификатору("КомментарииБазыЗнаний", Идентификатор);
		ИмяФормыСсылки		= "Справочник.КомментарииБазыЗнаний.Форма.ФормаРедактирования";
		
		ПараметрыОповещения	= Новый Структура;
		ПараметрыОповещения.Вставить("Ссылка"	, ЭлементСсылка);
		ПараметрыОповещения.Вставить("Статья"	, ТекущаяСсылка);
		
		ОписаниеОповещения	= Новый ОписаниеОповещения("ПослеИзмененияДанныхКомментария", ЭтотОбъект, ПараметрыОповещения);
	Иначе 
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЭлементСсылка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ссылка не определена.");
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Ключ", ЭлементСсылка);
	ОткрытьФорму(ИмяФормыСсылки, ПараметрыФормы, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАдресСсылки_delete(знач ДанныеСсылки)
	
	ПараметрыСсылки = ДанныеСсылки.Параметры;
	Если НЕ ПараметрыСсылки.Свойство("name") Тогда
		Возврат;
	КонецЕсли;
	
	ОбластьПерехода = "";
	
	Если ПараметрыСсылки.name = "comment" Тогда
		Идентификатор		= ?(ПараметрыСсылки.Свойство("id"), ПараметрыСсылки.id, "");
		КомментарийСсылка	= ПолучитьСсылкуПоИдентификатору("КомментарииБазыЗнаний", Идентификатор);
		УдалитьКомментарийНаСервере(КомментарийСсылка);
		ОбластьПерехода		= "comments";
	Иначе 
		Возврат;
	КонецЕсли;
	
	ОбновитьСтраницу(Неопределено);
	
	Если НЕ ПустаяСтрока(ОбластьПерехода) Тогда
		ПерейтиНаОбластьСтраницы(ОбластьПерехода);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАдресСсылки_rating(знач ДанныеСсылки)
	
	ПараметрыСсылки = ДанныеСсылки.Параметры;
	ИмяОбласти		= ?(ПараметрыСсылки.Свойство("name"), ПараметрыСсылки.name, "");
	Идентификатор	= ?(ПараметрыСсылки.Свойство("id"), ПараметрыСсылки.id, "");
	Если НЕ ПараметрыСсылки.name = "article" Тогда
		Возврат;
	ИначеЕсли ПустаяСтрока(Идентификатор) Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементСсылка	= ПолучитьСсылкуПоИдентификатору("СтатьиБазыЗнаний", Идентификатор);
	Если НЕ ЗначениеЗаполнено(ЭлементСсылка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ссылка не определена.");
		Возврат;
	КонецЕсли;
	
	ОбработкаОповещения = Новый ОписаниеОповещения("ПослеИзмененияДанныхСтатьи", ЭтотОбъект, Новый Структура("Статья", ЭлементСсылка));
	
	ПараметрыФормы = Новый Структура("Статья, Пользователь", ЭлементСсылка, ТекущийПользователь);
	ОткрытьФорму("Справочник.СтатьиБазыЗнаний.Форма.РедактированиеРейтинга", ПараметрыФормы, ЭтотОбъект, , , , ОбработкаОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАдресСсылки_refresh(знач ДанныеСсылки)
	
	Если ТипЗнч(ДанныеСсылки) = Тип("Строка") Тогда
		ДанныеСсылки = РазобратьАдресСсылкиНаСервере(ДанныеСсылки);
	КонецЕсли;
	
	ПараметрыСсылки = ДанныеСсылки.Параметры;
	Если НЕ ПараметрыСсылки.Свойство("name") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОбласти	= ПараметрыСсылки.name;
	ТекстHTML	= БазаЗнанийHTMLКлиент.ПолучитьЧастьСтраницыОбновления(ДанныеСсылки);

	НачПозиция = Найти(ДокументHTML, "id='" + ИмяОбласти + "'");
	Если НачПозиция > 0 Тогда
		ТекстHTMLУдалить = БазаЗнанийHTMLКлиентСервер.ВыделитьЭлементHTMLПоТегу(ДокументHTML, НачПозиция, "div");
		ДокументHTML = СтрЗаменить(ДокументHTML, ТекстHTMLУдалить, ТекстHTML);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАдресСсылки_search(знач ДанныеСсылки)
	
	ПараметрыСсылки = ДанныеСсылки.Параметры;
	ТекстПоиска	= ?(ПараметрыСсылки.Свойство("text"), ПараметрыСсылки.text, "");
	Если ПустаяСтрока(ТекстПоиска) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Значение для поиска не определено.");
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаПоиск.Видимость = Истина;
	УстановитьДоступность();
	
	СтрокаПоиска = ТекстПоиска;
	
	ВыполнитьПоиск(0);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАдресСсылки_subscribe(знач ДанныеСсылки)
	
	ПараметрыСсылки = ДанныеСсылки.Параметры;
	Если НЕ ПараметрыСсылки.Свойство("name") Тогда
		Возврат;
	КонецЕсли;
	Если НЕ ПараметрыСсылки.name = "category" Тогда
		Возврат;
	КонецЕсли;
	
	КатегорияСсылка = ПолучитьСсылкуПоИдентификатору("КатегорииБазыЗнаний", ПараметрыСсылки.id);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователь"			, ЭтотОбъект.ТекущийПользователь);
	ПараметрыФормы.Вставить("КатегорияБазыЗнаний"	, КатегорияСсылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеИзмененияДанныхПодписки", ЭтотОбъект, ПараметрыФормы);
	
	ОткрытьФорму("РегистрСведений.ИзбранноеБазыЗнаний.Форма.ФормаРедактирования", ПараметрыФормы, ЭтотОбъект, , , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигационнаяСсылка_mailto(ПараметрСсылки)
	ПочтовыйАдрес = Сред(ПараметрСсылки, 8);
	
	МассивКонтакты = ПолучитьКонтактыПоEMailНаСервере(ПочтовыйАдрес);
	ВзаимодействияКлиент.СоздатьНовоеВзаимодействие(
		"ЭлектронноеПисьмоИсходящее",
		Новый Структура("ЗначенияЗаполнения", Новый Структура("Контакты", МассивКонтакты)));
КонецПроцедуры

&НаКлиенте
Процедура НавигационнаяСсылка_file(ПараметрСсылки)
	
	ПутьКФайлу	= Сред(ПараметрСсылки, 6);
	Если Лев(ПутьКФайлу, 3) = "///" Тогда
		ПутьКФайлу = Сред(ПутьКФайлу, 4);
	КонецЕсли;
	
	// Уберем пробелы, с др. символами заморочимся потом
	ПутьКФайлу	= СтрЗаменить(ПутьКФайлу, "%20", " ");
	
	ОбъектФайл	= Новый Файл(ПутьКФайлу);
	Если НЕ ОбъектФайл.Существует() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Файл не найден. Открыть его не представляется возможным.");
		Возврат;
	КонецЕсли;
	
	ИмяФайла	= ОбъектФайл.ИмяБезРасширения;
	Расширение	= ОбъектФайл.Расширение;
	
	Если НЕ ЗначениеЗаполнено(Расширение) И Лев(ИмяФайла, 5) = "pict_" Тогда
		ПутьКФайлу = СтрЗаменить(ПутьКФайлу, "/", "\");
		ПараметрыФормы = Новый Структура("СтрокаHTML", "<html><body><img src='" + ПутьКФайлу + "'></body></html>");
		ОткрытьФорму("Справочник.СтатьиБазыЗнаний.Форма.ПросмотрHTML", ПараметрыФормы);
	Иначе 
		ЗапуститьПриложение(ПутьКФайлу);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НавигационнаяСсылка_kbapi(ПараметрСсылки, ВыделятьКлючевыеСлова = Ложь)
	
	АдресСтраницы	= ПараметрСсылки;
	ДанныеСсылки	= РазобратьАдресСсылкиНаСервере(АдресСтраницы);
	
	Если ДанныеСсылки.Команда = "page" Тогда
		ПерейтиНаСтраницу(ДанныеСсылки, ВыделятьКлючевыеСлова);
	ИначеЕсли ДанныеСсылки.Команда = "create" Тогда
		ОбработатьАдресСсылки_create(ДанныеСсылки);	
	ИначеЕсли ДанныеСсылки.Команда = "edit" Тогда
		ОбработатьАдресСсылки_edit(ДанныеСсылки);	
	ИначеЕсли ДанныеСсылки.Команда = "delete" Тогда
		ОбработатьАдресСсылки_delete(ДанныеСсылки);	
	ИначеЕсли ДанныеСсылки.Команда = "rating" Тогда
		ОбработатьАдресСсылки_rating(ДанныеСсылки);	
	ИначеЕсли ДанныеСсылки.Команда = "refresh" Тогда
		ОбработатьАдресСсылки_refresh(ДанныеСсылки);	
	ИначеЕсли ДанныеСсылки.Команда = "search" Тогда
		ОбработатьАдресСсылки_search(ДанныеСсылки);	
	ИначеЕсли ДанныеСсылки.Команда = "subscribe" Тогда
		ОбработатьАдресСсылки_subscribe(ДанныеСсылки);	
	Иначе 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ПараметрСсылки);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОПОВЕЩЕНИЙ

&НаКлиенте
Процедура ОбработатьОповещенияПользователя()
	
	ОтключитьОбработчикОжидания("ОбработатьОповещенияПользователя");
	
	//	ТекущийПользователь = БазаЗнанийКлиентСерверПовтИсп.ТекущийПользователь();
	//	
	//	МассивОповещений = БазаЗнанийВызовСервера.ПолучитьОповещенияПользователя(ТекущийПользователь, 1);
	//	Если МассивОповещений = Неопределено Тогда
	//		Возврат;
	//	КонецЕсли;
	//	
	//	Идентификаторы = Новый Массив;
	//	Для Каждого Структура Из МассивОповещений Цикл
	//		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Структура.Объект);
	//		
	//		ПоказатьОповещениеПользователя(Структура.Описание, НавигационнаяСсылка, "Перейти к комментарию", БиблиотекаКартинок.Информация);
	//		Идентификаторы.Добавить(Структура.Идентификатор);
	//	КонецЦикла;
	//	
	//	БазаЗнанийВызовСервера.УдалитьОповещенияПользователя(ТекущийПользователь, 1, Идентификаторы);
	//
	//ПодключитьОбработчикОжидания("ОбработатьОповещенияПользователя", 5, Ложь);
	//
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ МЕТОДЫ

&НаКлиенте
Процедура ОткрытьВнешнююСсылкуВыполнить(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗапуститьПриложение(ДопПараметры.Адрес);
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СтрокаHTML", ДопПараметры.Адрес);
		ПараметрыФормы.Вставить("Заголовок"	, ДопПараметры.Адрес);
		
		ОткрытьФорму("Справочник.СтатьиБазыЗнаний.Форма.ПросмотрHTML", ПараметрыФормы, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИзмененияДанныхКатегории(Результат, ДопПараметры) Экспорт
	
	ТекущаяСсылка = ПолучитьТекущуюСсылку(Объект.История, ТекущаяСтраница);
	
	Если ДопПараметры.Свойство("ЭтоНовый") И ДопПараметры.ЭтоНовый Тогда
		ОбновитьСтраницу(Неопределено);
	ИначеЕсли ДопПараметры.Свойство("Категория") И ДопПараметры.Категория = ТекущаяСсылка Тогда
		ОбновитьСтраницу(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИзмененияДанныхСтатьи(Результат, ДопПараметры) Экспорт
	
	ТекущаяСсылка = ПолучитьТекущуюСсылку(Объект.История, ТекущаяСтраница);
	
	Если ДопПараметры.Свойство("ЭтоНовый") И ДопПараметры.ЭтоНовый Тогда
		ОбновитьСтраницу(Неопределено);
	ИначеЕсли ДопПараметры.Свойство("Статья") И ДопПараметры.Статья = ТекущаяСсылка Тогда
		ОбновитьСтраницу(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИзмененияДанныхКомментария(Результат, ДопПараметры) Экспорт
	
	ТекущаяСсылка = ПолучитьТекущуюСсылку(Объект.История, ТекущаяСтраница);
	
	КомментарийСсылка	= ?(ДопПараметры.Свойство("Ссылка"), ДопПараметры.Ссылка, Неопределено);
	СтатьяСсылка		= ?(ДопПараметры.Свойство("Статья"), ДопПараметры.Статья, Неопределено);
	
	Если ЗначениеЗаполнено(КомментарийСсылка) Тогда
		Объект.Область = "comment_" + Строка(КомментарийСсылка.УникальныйИдентификатор());
	Иначе 
		Объект.Область = "comments";
	КонецЕсли;
	
	Если СтатьяСсылка = ТекущаяСсылка Тогда
		ПараметрыСсылки = Новый Структура("name, article",
			"comments",
			Строка(СтатьяСсылка.УникальныйИдентификатор()));
		ДанныеСсылки	= Новый Структура("Команда, Параметры", "refresh", ПараметрыСсылки);
		ОбработатьАдресСсылки_refresh(ДанныеСсылки);
	Иначе 
		ОбновитьСтраницу(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИзмененияДанныхПодписки(Результат, ДопПараметры) Экспорт
	
	// ничего делать не будем пока
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	БазаЗнаний.ЗавершитьСессииПользователя(КлючСессии);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьКомментарийНаСервере(КомментарийСсылка)
	Справочники.КомментарииБазыЗнаний.УдалитьКомментарий(КомментарийСсылка);
КонецПроцедуры

&НаСервереБезКонтекста
Функция РазобратьАдресСсылкиНаСервере(АдресСсылки)
	
	Возврат БазаЗнанийAPIКлиентСервер.РазобратьАдресСсылки(АдресСсылки);
	
КонецФункции

&НаСервереБезКонтекста
Функция КонструкторСсылки_page(ИмяСтраницы, Параметры)
	
	Возврат БазаЗнанийAPIКлиентСервер.КонструкторСсылки_page(ИмяСтраницы, Параметры);
	
КонецФункции

// Основное окно портала

&НаКлиенте
Функция ВыбратьМестоСохранения(Каталог)
	
	Если Каталог Тогда
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	Иначе 
		Режим = РежимДиалогаВыбораФайла.Сохранение;
	КонецЕсли;
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(Режим);
	Если ДиалогВыбора.Выбрать() Тогда
		Возврат ДиалогВыбора.Каталог;
	Иначе 
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьТекущуюСсылку(ТаблицаИстория, ТекущаяСтрока)
	
	Если ТекущаяСтрока <= 0 ИЛИ ТекущаяСтрока > ТаблицаИстория.Количество() Тогда
		ТекущаяСтрока = ТаблицаИстория.Количество();
	КонецЕсли;
	
	Если ТекущаяСтрока = 0 Тогда
		Возврат "";
	Иначе 
		Возврат ТаблицаИстория[ТекущаяСтрока - 1].СсылкаСтраницы;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьТекущийАдресСсылки(ТаблицаИстория, ТекущаяСтрока)
	
	Если ТекущаяСтрока <= 0 ИЛИ ТекущаяСтрока > ТаблицаИстория.Количество() Тогда
		ТекущаяСтрока = ТаблицаИстория.Количество();
	КонецЕсли;
	
	Если ТекущаяСтрока = 0 Тогда
		Возврат "";
	Иначе 
		Возврат ТаблицаИстория[ТекущаяСтрока - 1].АдресСсылки;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УдалитьПоследующиеСтрокиИстории(ТекСтраница, История)
	
	МассивСтрок = Новый Массив;
	Для Каждого СтрокаИстории Из История Цикл
		Если СтрокаИстории.НомерСтроки > ТекСтраница Тогда
			МассивСтрок.Добавить(СтрокаИстории);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из МассивСтрок Цикл
		История.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДобавитьКлючевыеСловаПоСтрокеПоиска(КлючевыеСлова, ЗначениеСтроки)
	ОператорыПП = Новый Массив;
	ОператорыПП.Добавить("И");
	ОператорыПП.Добавить("AND");
	ОператорыПП.Добавить("#");
	ОператорыПП.Добавить("ИЛИ");
	ОператорыПП.Добавить("OR");
	ОператорыПП.Добавить("|");
	ОператорыПП.Добавить("НЕ");
	ОператорыПП.Добавить("NOT");
	ОператорыПП.Добавить("~");
	
	МассивСлов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЗначениеСтроки, " ");
	Для Каждого Слово Из МассивСлов Цикл
		Если ОператорыПП.Найти(Слово) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Слово = СокрЛП(Слово);
		
		Если Лев(Слово, 5) = "РЯДОМ" ИЛИ Лев(Слово, 4) = "NEAR" Тогда
			Продолжить;
		ИначеЕсли Лев(Слово, 1) = "/" И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Сред(Слово, 2, 1)) Тогда
			Продолжить;
		ИначеЕсли Слово = "(" ИЛИ Слово = ")" Тогда
			Продолжить;
		ИначеЕсли Лев(Слово, 1) = "#" Тогда
			Слово = Сред(Слово, 2);
		ИначеЕсли Найти(Слово, "#") Тогда
			Позиция = Найти(Слово, "#");
			Слово	= Лев(Слово, Позиция - 1);
		ИначеЕсли Лев(Слово, 1) = "!" Тогда
			Слово = Сред(Слово, 2);
		ИначеЕсли Прав(Слово, 1) = "*" Тогда
			Слово = Лев(Слово, СтрДлина(Слово) - 1);
		КонецЕсли;
		
		КлючевыеСлова.Добавить(Слово);
	КонецЦикла;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСсылкуПоИдентификатору(ВидСправочника, Идентификатор)
	
	Если НЕ ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат Справочники[ВидСправочника].ПустаяСсылка();
	КонецЕсли;
	
	УникальныйИдентификатор = Новый УникальныйИдентификатор(Идентификатор);
	Возврат Справочники[ВидСправочника].ПолучитьСсылку(УникальныйИдентификатор);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьКонтактыПоEMailНаСервере(ПочтовыйАдрес, Представление = "")
	
	Массив = Новый Массив;
	
	ТаблицаКонтактов	= Взаимодействия.ПолучитьВсеКонтактыПоEmail(ПочтовыйАдрес);
	Для Каждого СтрокаТаблицы Из ТаблицаКонтактов Цикл
		Массив.Добавить(
			Новый Структура("Адрес, Представление, Контакт",
				ПочтовыйАдрес, СтрокаТаблицы.Наименование, СтрокаТаблицы.Контакт));
	КонецЦикла;
	
	Если Массив.Количество() = 0 Тогда
		Массив.Добавить(
			Новый Структура("Адрес, Представление, Контакт",
				ПочтовыйАдрес, ?(ПустаяСтрока(Представление), ПочтовыйАдрес, Представление), Неопределено));
	КонецЕсли;
	
	Возврат Массив;
	
КонецФункции

&НаСервереБезКонтекста
Функция ДобавитьИнформациюОПросмотреНаСервере(ЭлементСсылка, ТекущийПользователь = Неопределено)
	
	ТипСсылки = ТипЗнч(ЭлементСсылка);
	Если ТипСсылки = Тип("СправочникСсылка.СтатьиБазыЗнаний") Тогда
		БазаЗнаний.ДобавитьПросмотрСтатьи(ЭлементСсылка);
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка.НовостиБазыЗнаний") Тогда
		БазаЗнаний.ДобавитьПросмотрНовости(ЭлементСсылка, ТекущийПользователь);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПерейтиНаСтраницу(знач ДанныеСсылки, знач ПараметрыВывода = Неопределено)
	
	Если ТипЗнч(ДанныеСсылки) = Тип("Строка") Тогда
		ДанныеСсылки = РазобратьАдресСсылкиНаСервере(АдресСтраницы);
	КонецЕсли;
	
	ПараметрыСсылки = ДанныеСсылки.Параметры;
	Если НЕ ПараметрыСсылки.Свойство("name") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТипЗнч(ПараметрыВывода) = Тип("Структура") Тогда
		ПараметрыВывода = Новый Структура;
	КонецЕсли;
	
	Обновление				= ?(ПараметрыВывода.Свойство("Обновление"), ПараметрыВывода.Обновление, Ложь);
	ВыделятьКлючевыеСлова	= ?(ПараметрыВывода.Свойство("ВыделятьКлючевыеСлова"), ПараметрыВывода.ВыделятьКлючевыеСлова, Ложь);
	
	ТекущийАдрес = ПолучитьТекущийАдресСсылки(Объект.История, ТекущаяСтраница);
	Если ТекущийАдрес = АдресСтраницы И НЕ Обновление Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыСсылки.name = "article" Тогда
		Идентификатор	= ПараметрыСсылки.id;
		ЭлементСсылка	= ПолучитьСсылкуПоИдентификатору("СтатьиБазыЗнаний", Идентификатор);
		ТекущаяСсылка	= ПолучитьТекущуюСсылку(Объект.История, ТекущаяСтраница);
		
		РазделИд = ?(ПараметрыСсылки.Свойство("section"), ПараметрыСсылки.section, "");
		Если ЭлементСсылка = ТекущаяСсылка И ЗначениеЗаполнено(РазделИд) Тогда
			ПерейтиНаОбластьСтраницы(РазделИд);
			
			Объект.СтатьяБазыЗнаний = Неопределено;
			Объект.Область			= "";
			
			Возврат;
		КонецЕсли;
		
		Объект.СтатьяБазыЗнаний = ЭлементСсылка;
		Объект.Область			= РазделИд;
		
		ПараметрыВывода.Вставить("ВыделятьКлючевыеСлова", ВыделятьКлючевыеСлова);

		ДобавитьИнформациюОПросмотреНаСервере(ЭлементСсылка);
	ИначеЕсли ПараметрыСсылки.name = "category" Тогда
		Идентификатор	= ПараметрыСсылки.id;
		ЭлементСсылка	= ПолучитьСсылкуПоИдентификатору("КатегорииБазыЗнаний", Идентификатор);
	ИначеЕсли ПараметрыСсылки.name = "tag" Тогда
		Идентификатор	= ПараметрыСсылки.id;
		ЭлементСсылка	= ПолучитьСсылкуПоИдентификатору("КлючевыеСловаБазыЗнаний", Идентификатор);
	ИначеЕсли ПараметрыСсылки.name = "news_item" Тогда
		Идентификатор	= ПараметрыСсылки.id;
		ЭлементСсылка	= ПолучитьСсылкуПоИдентификатору("НовостиБазыЗнаний", Идентификатор);

		ДобавитьИнформациюОПросмотреНаСервере(ЭлементСсылка, ТекущийПользователь);
	Иначе 
		ЭлементСсылка	= Неопределено;
	КонецЕсли;
	
	Если ТекущаяСтраница > 0 Тогда
		УдалитьПоследующиеСтрокиИстории(ТекущаяСтраница, Объект.История);
	КонецЕсли;
	
	ЭтотОбъект.ДокументHTML = БазаЗнанийHTMLКлиент.ПолучитьТекстСтраницы(ДанныеСсылки);
	
	Если ТекущийАдрес <> АдресСтраницы Тогда
		НоваяСтрока = Объект.История.Добавить();
		НоваяСтрока.ТекстСтраницы	= ЭтотОбъект.ДокументHTML;
		НоваяСтрока.АдресСсылки		= АдресСтраницы;
		НоваяСтрока.СсылкаСтраницы	= ЭлементСсылка;
	КонецЕсли;
	
	ЭтотОбъект.ТекущаяСтраница	= Объект.История.Количество();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаОбластьСтраницы(ОбластьПерехода);
	Элементы.ДокументHTML.Документ.parentWindow.eval("scroller.goto('#" + ОбластьПерехода + "');");
КонецПроцедуры

// Полнотекстовый поиск

&НаКлиенте
Процедура ВыполнитьПоиск(Направление)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите значение, которое необходимо найти.'"), , "СтрокаПоиска");
		Возврат;
	КонецЕсли;
	
	ТекстСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполняется поиск ""%1""...'"),
		СтрокаПоиска);
	Состояние(ТекстСостояния, , , БиблиотекаКартинок.Лупа);
	
	Результат = ВыполнитьПолнотекстовыйПоискНаСервере(Направление, ТекущаяПозицияПоиска, СтрокаПоиска);
	
	РезультатыПоиска		= Результат.РезультатПоиска;
	HTMLТекст				= Результат.HTMLТекст;
	ТекущаяПозицияПоиска	= Результат.ТекущаяПозиция;
	ПолноеКоличество		= Результат.ПолноеКоличество;
	КлючевыеСлова.ЗагрузитьЗначения(Результат.КлючевыеСлова);
	
	Если РезультатыПоиска.Количество() > 0 Тогда
		
		ПоказаныРезультатыСПо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Показаны %1 - %2 из %3'"),
			Формат(ТекущаяПозицияПоиска + 1, "ЧН=0; ЧГ="),
			Формат(ТекущаяПозицияПоиска + РезультатыПоиска.Количество(), "ЧН=0; ЧГ="),
			Формат(ПолноеКоличество, "ЧН=0; ЧГ="));
		
		Элементы.СледующаяСтраницаПоиска.Доступность	= (ПолноеКоличество - ТекущаяПозицияПоиска) > РезультатыПоиска.Количество();
		Элементы.ПредыдущаяСтраницаПоиска.Доступность	= (ТекущаяПозицияПоиска > 0);
		
		Если Направление = 0 И Результат.ТекущаяПозиция = 0 И Результат.СлишкомМногоРезультатов Тогда
			Предупреждение(НСтр("ru = 'Слишком много результатов, уточните запрос.'"));
		КонецЕсли;
		
	Иначе
		
		ПоказаныРезультатыСПо = НСтр("ru = 'Не найдено'");
		
		Элементы.СледующаяСтраницаПоиска.Доступность	= Ложь;
		Элементы.ПредыдущаяСтраницаПоиска.Доступность	= Ложь;
		
		ТекстПоиска = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Комбинация слов ""%1"" нигде не встречается.<br><br>
			|<b>Рекомендации:</b>
			|<li>Убедитесь, что все слова написаны без ошибок.
			|<li>Попробуйте использовать другие ключевые слова.
			|<li>Попробуйте уменьшить количество искомых слов.'"),
			СокрЛП(СтрокаПоиска));
		
		HTMLТекст = 
		"<html>
		|<head>
		|</head>
		|<body>
		|" + ТекстПоиска + "
		|</body>
		|</html>";
		
	КонецЕсли;
	
	РезультатПоискаHTML = БазаЗнанийКлиент.ОбработатьРезультатПолнотекстовогоПоиска(HTMLТекст, РезультатыПоиска);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыполнитьПолнотекстовыйПоискНаСервере(Направление, ТекущаяПозиция, СтрокаПоиска)
	
	ОбластьПоиска = Новый Массив;
	ОбластьПоиска.Добавить(Метаданные.Справочники.СтатьиБазыЗнаний);
	
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска, 10);
	СписокПоиска.ОбластьПоиска = ОбластьПоиска;
	
	Если Направление = 0 Тогда
		СписокПоиска.ПерваяЧасть();
	ИначеЕсли Направление = -1 Тогда
		СписокПоиска.ПредыдущаяЧасть(ТекущаяПозиция);
	ИначеЕсли Направление = 1 Тогда
		СписокПоиска.СледующаяЧасть(ТекущаяПозиция);
	КонецЕсли;
	
	// Массив значений
	МассивЭлементов = Новый Массив;
	Для Каждого ЭлементСписка Из СписокПоиска Цикл
		МассивЭлементов.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	
	// Ключевые слова
	КлючевыеСлова = Новый Массив;
	ДобавитьКлючевыеСловаПоСтрокеПоиска(КлючевыеСлова, СтрокаПоиска);
	
	ЧтениеXML	= СписокПоиска.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.XML);
	Результат	= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	ВсеСвойства	= Результат.Свойства();
	Если НЕ ВсеСвойства.Получить("item") = Неопределено Тогда
		Если ТипЗнч(Результат.item) = Тип("СписокXDTO") Тогда
			ОбработатьСписокXDTOПоиска(КлючевыеСлова, Результат.item);
		ИначеЕсли ТипЗнч(Результат.item) = Тип("ОбъектXDTO") Тогда
			ОбработатьОбъектXDTOПоиска(КлючевыеСлова, Результат.item);
		КонецЕсли;
	КонецЕсли;
	
	// Прочие данные поиска
	HTMLТекст 				= СписокПоиска.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
	ТекущаяПозиция			= СписокПоиска.НачальнаяПозиция();
	ПолноеКоличество		= СписокПоиска.ПолноеКоличество();
	СлишкомМногоРезультатов	= СписокПоиска.СлишкомМногоРезультатов();
	
	Результат = Новый Структура;
	Результат.Вставить("РезультатПоиска"		, МассивЭлементов);
	Результат.Вставить("КлючевыеСлова"			, КлючевыеСлова);
	Результат.Вставить("ТекущаяПозиция"			, ТекущаяПозиция);
	Результат.Вставить("ПолноеКоличество"		, ПолноеКоличество);
	Результат.Вставить("HTMLТекст"				, HTMLТекст);
	Результат.Вставить("СлишкомМногоРезультатов", СлишкомМногоРезультатов);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОбработатьОбъектXDTOСловоПоиска(СписокСлов, ОбъектXDTO)
	
	СвойстваОбъекта	= ОбъектXDTO.Свойства();
	СвойствоСлово	= СвойстваОбъекта.Получить("foundWord");
	Если СвойствоСлово = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СловоПоиска = ОбъектXDTO.foundWord;
	Если ТипЗнч(СловоПоиска) = Тип("СписокXDTO") Тогда
		Для Каждого ЭлементСписка Из СловоПоиска Цикл
			Если ТипЗнч(ЭлементСписка) = Тип("Строка") Тогда
				Если СписокСлов.Найти(ЭлементСписка) = Неопределено Тогда
					СписокСлов.Добавить(ЭлементСписка);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(СловоПоиска) = Тип("Строка") Тогда
		Если СписокСлов.Найти(СловоПоиска) = Неопределено Тогда
			СписокСлов.Добавить(СловоПоиска);
		КонецЕсли;
	КонецЕсли;		
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьСписокXDTOПоиска(СписокСлов, СписокXDTO)
	Для Каждого ОбъектXDTO Из СписокXDTO Цикл
		ОбработатьОбъектXDTOПоиска(СписокСлов, ОбъектXDTO);
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьОбъектXDTOПоиска(СписокСлов, ОбъектXDTO)
	СвойстваОбъекта = ОбъектXDTO.Свойства();
	
	СвойствоТекст = СвойстваОбъекта.Получить("textPortion");
	Если СвойствоТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеСвойства = ОбъектXDTO.textPortion;
	Если ТипЗнч(ЗначениеСвойства) = Тип("СписокXDTO") Тогда
		Для Каждого ОбъектСписка Из ЗначениеСвойства Цикл
			ОбработатьОбъектXDTOСловоПоиска(СписокСлов, ОбъектСписка);
		КонецЦикла;
	ИначеЕсли ТипЗнч(ЗначениеСвойства) = Тип("ОбъектXDTO") Тогда
		ОбработатьОбъектXDTOСловоПоиска(СписокСлов, ЗначениеСвойства);
	КонецЕсли;		
КонецПроцедуры
