﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторПользователя = Пользователи.ТекущийПользователь().ИдентификаторПользователяСервиса;
	ИдентификаторИдеи = Параметры.ИдентификаторИдеи;
	ТекущаяСтраницаКомментариев = Параметры.ТекущаяСтраницаКомментариев;
	
	ЗаполнитьИдею();
	
	ИнформационныйЦентрСервер.УстановитьПризнакПросмотраИдеи(Новый УникальныйИдентификатор(ИдентификаторИдеи));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДобавленКомментарийКИдее" Или ИмяСобытия = "УдаленКомментарийКИдее" Тогда 
		ПереоткрытьДаннуюФормуСПараметрами();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветитьНажатие(Элемент)
	
	НомерКомментария = ПолучитьНомерКомментарияПоНазванию(Элемент.Имя);
	ИдентификаторКомментария = Комментарии.Получить(НомерКомментария - 1).Идентификатор;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИдентификаторИдеи", ИдентификаторИдеи);
	ПараметрыФормы.Вставить("ИдентификаторКомментария", ИдентификаторКомментария);
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ОтветНаКомментарийКИдее", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьКомментарийОповещение", ЭтотОбъект, Элемент.Имя);
	
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Удалить Ваш комментарий?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаВлевоНажатие(Элемент)
	
	ТекущаяСтраницаКомментариев = ТекущаяСтраницаКомментариев - 1;
	ПереоткрытьДаннуюФормуСПараметрами();
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаВправоНажатие(Элемент)
	
	ТекущаяСтраницаКомментариев = ТекущаяСтраницаКомментариев + 1;
	ПереоткрытьДаннуюФормуСПараметрами();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Минус(Команда)
	
	ПроголосоватьЗаИдею(-1);
	Оповестить("ПроголосовалиЗаИдею");
	ПереоткрытьДаннуюФормуСПараметрами();
	
КонецПроцедуры

&НаКлиенте
Процедура Плюс(Команда)
	
	ПроголосоватьЗаИдею(1);
	Оповестить("ПроголосовалиЗаИдею");
	ПереоткрытьДаннуюФормуСПараметрами();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКомментарий(Команда)
	
	Если ПустаяСтрока(ТекстКомментария) Тогда 
		ВызватьИсключение НСтр("ru = 'Поле комментарий должно быть заполнено'");
	КонецЕсли;
	ДобавитьКомментарийСервер();
	Оповестить("ДобавленКомментарийКИдее");
	
	ПоказатьОповещениеПользователя("ru = 'Комментарий добавлен'");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УдалитьКомментарийОповещение(Ответ, ИмяЭлемента) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	КонецЕсли;
	
	НомерКомментария = ПолучитьНомерКомментарияПоНазванию(ИмяЭлемента);
	ИдентификаторКомментария = Комментарии.Получить(НомерКомментария - 1).Идентификатор;
	УдалитьКомментарий(ИдентификаторКомментария);
	Оповестить("УдаленКомментарийКИдее");
	
	ПоказатьОповещениеПользователя("ru = 'Комментарий удален'");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИдею()
	
	ДанныеПоИдее = ПолучитьДанныеПоИдее();
	СформироватьСтраницу(ДанныеПоИдее);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеПоИдее()
	
	WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиЦентраИдей();
	Возврат WSПрокси.getIdea(ИдентификаторИдеи, Строка(ИдентификаторПользователя), ТекущаяСтраницаКомментариев, ИнформационныйЦентрСервер.КоличествоКомментариевКИдееНаСтранице());
	
КонецФункции

&НаСервере
Процедура СформироватьСтраницу(Знач ДанныеПоИдее)
	
	ПредставлениеИдеи = ДанныеПоИдее.Idea;
	
	// Отображение заголовка идеи
	Заголовок = ПредставлениеИдеи.Name;
	
	// Отображение предзаголовка идеи
	Элементы.Предзаголовок.Заголовок = ИнформационныйЦентрСервер.СформироватьПредзаголовокИдеи(ПредставлениеИдеи);
	Элементы.Предмет.Заголовок = ПредставлениеИдеи.Subject;
	
	// Отображение комментария разработчика
	Элементы.КомментарийРазработчика.Видимость = Не ПустаяСтрока(ПредставлениеИдеи.developerComment);
	Элементы.КомментарийРазработчика.Заголовок = ПредставлениеИдеи.developerComment;
	КомментарийРазработчика = ПредставлениеИдеи.developerComment;
	
	// Отображение заголовка
	Если ПредставлениеИдеи.Status = "plan" Тогда 
		Элементы.НаГолосовании_1.Видимость = Ложь;
		ОтобразитьЗапланированнуюИдею(ПредставлениеИдеи);
	ИначеЕсли ПредставлениеИдеи.Status = "voiting" Тогда
		Элементы.НаГолосовании_1.Видимость = Истина;
		ОтобразитьИдеюНаГолосовании(ПредставлениеИдеи);
	ИначеЕсли ПредставлениеИдеи.Status = "deviation" Тогда 
		Элементы.НаГолосовании_1.Видимость = Ложь;
		ОтобразитьОтклоненнуюИдею(ПредставлениеИдеи);
	ИначеЕсли ПредставлениеИдеи.Status = "realization" Тогда 
		Элементы.НаГолосовании_1.Видимость = Ложь;
		ОтобразитьРеализованнуюИдею(ПредставлениеИдеи);
	ИначеЕсли ПредставлениеИдеи.Status = "consideration" Тогда 
		Элементы.НаГолосовании_1.Видимость = Ложь;
		ОтобразитьДобавленнуюИдею(ПредставлениеИдеи);
	КонецЕсли;
	
	// Отображение содержания
	ОтобразитьСодержание(ПредставлениеИдеи);
	
	СписокКомментариев = ДанныеПоИдее.CommentsList;
	// Отображение комментариев
	Для Итерация = 1 По ИнформационныйЦентрСервер.КоличествоКомментариевКИдееНаСтранице() Цикл
		
		Если СписокКомментариев.Количество() >= Итерация Тогда 
			ПредставлениеКомментария = СписокКомментариев.Получить(Итерация - 1);
			НовыйКомментарий = Комментарии.Добавить();
			НовыйКомментарий.Идентификатор = ПредставлениеКомментария.Id;
		Иначе
			Элементы["СтраницыКомментария_" + Итерация].ТекущаяСтраница = Элементы["СтраницаПустогоКомментария_" + Итерация];
			Продолжить;
		КонецЕсли;
		
		ОтобразитьКомментарий(ПредставлениеКомментария, Итерация);
		
	КонецЦикла;
	
	// Отображение подвала
	ЕстьСтраницыДо = ?(ТекущаяСтраницаКомментариев > 1, Истина, Ложь);
	ЕстьСтраницыПосле = ?(СписокКомментариев.Количество() > ИнформационныйЦентрСервер.КоличествоКомментариевКИдееНаСтранице(), Истина, Ложь);
	
	Элементы.НомерСтраницы.Заголовок = ТекущаяСтраницаКомментариев;
	Элементы.КнопкаВлево.Гиперссылка = ЕстьСтраницыДо;
	Элементы.КнопкаВлево.Картинка = ?(ЕстьСтраницыДо, БиблиотекаКартинок.ПереходВлевоАктивный, БиблиотекаКартинок.ПереходВлевоНеАктивный);
	Элементы.НомерСтраницы.Заголовок = ТекущаяСтраницаКомментариев;
	Элементы.КнопкаВправо.Гиперссылка = ЕстьСтраницыПосле;
	Элементы.КнопкаВправо.Картинка = ?(ЕстьСтраницыПосле, БиблиотекаКартинок.ПереходВправоАктивный, БиблиотекаКартинок.ПереходВправоНеАктивный);
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьЗапланированнуюИдею(Знач ПредставлениеИдеи)
	
	Элементы.Идея_1.ТекущаяСтраница = Элементы.Запланированная_1;
	Элементы.ДополнительныйПараметр.Заголовок = ИнформационныйЦентрСервер.СформироватьЗаголовокДатыРеализации(ПредставлениеИдеи);
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьИдеюНаГолосовании(Знач ПредставлениеИдеи)
	
	Элементы.Идея_1.ТекущаяСтраница = Элементы.НаГолосовании_1;
	
	Если ПредставлениеИдеи.Vote > 0 Тогда 
		Элементы.СтраницыКомандНаГолосовании_1.ТекущаяСтраница = Элементы.СтраницаГолосМинус_1;
		Элементы.НаМинусе_Рейтинг_1.Заголовок = ПредставлениеИдеи.Rating;
	ИначеЕсли ПредставлениеИдеи.Vote < 0 Тогда
		Элементы.СтраницыКомандНаГолосовании_1.ТекущаяСтраница = Элементы.СтраницаГолосПлюс_1;
		Элементы.НаПлюсе_Рейтинг_1.Заголовок = ПредставлениеИдеи.Rating;
	Иначе
		Элементы.СтраницыКомандНаГолосовании_1.ТекущаяСтраница = Элементы.СтраницаГолосБезГолоса_1;
		Элементы.БезГолоса_Рейтинг_1.Заголовок = ПредставлениеИдеи.Rating;
	КонецЕсли;
	
	Элементы.ДополнительныйПараметр.Видимость = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьОтклоненнуюИдею(Знач ПредставлениеИдеи)
	
	Элементы.Идея_1.ТекущаяСтраница = Элементы.Отклоненная_1;
	Элементы.ДополнительныйПараметр.Заголовок = ИнформационныйЦентрСервер.СформироватьДатуОтклонения(ПредставлениеИдеи);
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьРеализованнуюИдею(Знач ПредставлениеИдеи)
	
	Элементы.Идея_1.ТекущаяСтраница = Элементы.Реализованная_1;
	Элементы.ДополнительныйПараметр.Заголовок = ИнформационныйЦентрСервер.СформироватьДатуРеализации(ПредставлениеИдеи);
	Элементы.ГруппаКомментарийПользователя.Видимость = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьДобавленнуюИдею(Знач ПредставлениеИдеи)
	
	Элементы.Идея_1.ТекущаяСтраница = Элементы.Добавленная_1;
	Элементы.ДополнительныйПараметр.Видимость = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьСодержание(Знач ПредставлениеИдеи)
	
	HTMLТекст = ПредставлениеИдеи.HTMLText;
	
	// Поместить во временное хранилище картинки
	Для Каждого ДД Из ПредставлениеИдеи.Attachments Цикл 
		Картинка = Новый Картинка(ДД.Data);
		АдресХранилища = ПоместитьВоВременноеХранилище(Картинка);
		HTMLТекст = СтрЗаменить(HTMLТекст, ДД.Name, АдресХранилища);
	КонецЦикла;
	
	Содержание = HTMLТекст;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьКомментарий(Знач ПредставлениеКомментария, Знач Итерация)
	
	Элементы["СтраницыКомментария_" + Итерация].ТекущаяСтраница = Элементы["СтраницаКомментария_" + Итерация];
	Элементы["КомментарийЗаголовок_" + Итерация].Заголовок = ИнформационныйЦентрСервер.СформироватьПредзаголовокКомментария(ПредставлениеКомментария);
	Элементы["КомментарийЗаголовок_" + Итерация].ЦветТекста = ?(ПредставлениеКомментария.IsSupport, Новый Цвет(0, 128, 0), Новый Цвет(153, 153, 153));
	
	КомментарийТекущегоПользователя = (ПредставлениеКомментария.UserId = Строка(ИдентификаторПользователя));
	Элементы["КартинкаОтветить_" + Итерация].Видимость = ?(КомментарийТекущегоПользователя, Ложь, Истина);
	Элементы["Ответить_" + Итерация].Видимость = ?(КомментарийТекущегоПользователя, Ложь, Истина);
	
	Элементы["КартинкаУдалить_" + Итерация].Видимость = ?(КомментарийТекущегоПользователя, Истина, Ложь);
	Элементы["Удалить_" + Итерация].Видимость = ?(КомментарийТекущегоПользователя, Истина, Ложь);
	
	ДобавлениеКТексту = "";
	Если ПредставлениеКомментария.MainIdeaComment <> Неопределено Тогда 
		ЗаголовокПользователя = ПредставлениеКомментария.MainIdeaComment.UserName;
		ДобавлениеКТексту = ЗаголовокПользователя + ", ";
	КонецЕсли;
    
    ПозицияНачалаКонтекста = Найти(ПредставлениеКомментария.Text, "<!-- @AddInfo");
    Если ПозицияНачалаКонтекста <> 0 Тогда
        ПредставлениеКомментария.Text = СокрЛП(Лев(ПредставлениеКомментария.Text, ПозицияНачалаКонтекста - 1));
    КонецЕсли;
    
    Элементы["Комментарий" + Итерация].Заголовок = ДобавлениеКТексту + ПредставлениеКомментария.Text;
	Элементы["Комментарий" + Итерация].Подсказка = ПредставлениеКомментария.Text;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереоткрытьДаннуюФормуСПараметрами()
	
	Закрыть();
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИдентификаторИдеи", ИдентификаторИдеи);
	ПараметрыФормы.Вставить("ТекущаяСтраницаКомментариев", ТекущаяСтраницаКомментариев);
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.Идея", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура ПроголосоватьЗаИдею(Знач Голос)
	
	Попытка
		WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиЦентраИдей();
		ИнформационныйЦентрСервер.ПроголосоватьЗаИдею(WSПрокси, Строка(ИдентификаторПользователя), ИдентификаторИдеи, Голос);
	Исключение
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,
		                         ,
		                         ,ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВЦентреИдей();
		ВызватьИсключение ТекстВывода;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьНомерКомментарияПоНазванию(Знач ИмяЭлемента)
	
	МассивЭлементов = СтрРазделить(ИмяЭлемента, "_");
	КоличествоЭлементов = МассивЭлементов.Количество();
	Если КоличествоЭлементов = 0 Тогда 
		Возврат 0;
	КонецЕсли;
	
	Попытка
		ПолучитьНомерКомментарияПоНазванию = Число(МассивЭлементов.Получить(КоличествоЭлементов - 1));
	Исключение
		ПолучитьНомерКомментарияПоНазванию = 0;
	КонецПопытки;
	
	Возврат ПолучитьНомерКомментарияПоНазванию;
	
КонецФункции

&НаСервере
Процедура ДобавитьКомментарийСервер()
	
	Попытка
        Текст = ТекстКомментария;
        Обработки.ИнформационныйЦентр.ДобавитьИнформациюОПриложении(Текст);
		WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиЦентраИдей();
		WSПрокси.addIdeaComment(ИдентификаторИдеи, Строка(ИдентификаторПользователя), "", Текст);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,
		                         ,
		                         ,ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВЦентреИдей();
		ВызватьИсключение ТекстВывода;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьКомментарий(Знач ИдентификаторКомментария)
	
	Попытка
		WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиЦентраИдей();
		WSПрокси.deleteIdeaComment(ИдентификаторКомментария);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,
		                         ,
		                         ,ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВЦентреИдей();
		ВызватьИсключение ТекстВывода;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти


