﻿#Область СлужебныеПроцедурыИФункции

// Функция формирует структуру, необходимую для установки индекса картинки 
// в таблице событий журнала регистрации.
//
Функция НомераКартинокСобытий152ФЗ() Экспорт
	
	НомераКартинок = Новый Соответствие;
	НомераКартинок.Вставить("_$Session$_.Authentication",		1);
	НомераКартинок.Вставить("_$Session$_.AuthenticationError",	2);
	НомераКартинок.Вставить("_$Session$_.Start",				3);
	НомераКартинок.Вставить("_$Session$_.Finish",				4);
	НомераКартинок.Вставить("_$Access$_.Access",				5);
	НомераКартинок.Вставить("_$Access$_.AccessDenied",			6);
	
	Возврат Новый ФиксированноеСоответствие(НомераКартинок);
	
КонецФункции

#КонецОбласти
