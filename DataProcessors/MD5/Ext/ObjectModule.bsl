﻿Перем A,B,C,D; 
Перем A_,B_,C_,D_;
Перем EAX,EBX,ECX,EDX; // Регистры
Перем S11,S12,S13,S14,S21,S22,S23,S24,S31,S32,S33,S34,S41,S42,S43,S44;
Перем M;
Перем Степень;
Перем Stepen31; //2 в степени 31
Перем Stepen32; //2 в степени 32
Перем X;    //Текстовый массив в числовом коде

Функция РасчетХЭШ(СтрокаХэш)Экспорт
	
	Попытка
		//ХэшКод = MD5Script(СтрокаХэш);
		ХэшКод = MD5Win(СтрокаХэш);
		Возврат ХэшКод;
	Исключение	
	
	A_ = Массив(32);
	B_ = Массив(32);
	C_ = Массив(32);
	D_ = Массив(32);

	EAX = Массив(32);
	EBX = Массив(32);
	ECX = Массив(32);
	EDX = Массив(32);
	 
	M = Массив(64);

	Степень = Массив(32);
	 
	X = Массив(16);

	S11 =  7;
	S12 = 12;
	S13 = 17;
	S14 = 22;
	S21 =  5;
	S22 =  9;
	S23 = 14;
	S24 = 20;
	S31 =  4;
	S32 = 11;
	S33 = 16;
	S34 = 23;
	S41 =  6;
	S42 = 10;
	S43 = 15;
	S44 = 21;

	Степень[1]=1;
	Для инд=2 По 32 Цикл
		Степень[инд]=Степень[инд-1]*2;
	КонецЦикла;
	Stepen31=Степень[32];
	Stepen32=Stepen31*2;
	//--
	
	A	=	1732584193;
	B	=	4023233417;
	C	=	2562383102;
	D	=	271733878;
	Для i=1 По 32 Цикл
		i1=32-i+1;
		Степ=Степень[i1];
		Если A >= Степ Тогда
			A=A-Степ;
			A_[i1]=1;
		Иначе
			A_[i1]=0;
		КонецЕсли;
		Если B >= Степ Тогда
			B=B-Степ;
			B_[i1]=1;
		Иначе
			B_[i1]=0;
		КонецЕсли;
		Если C >= Степ Тогда
			C=C-Степ;
			C_[i1]=1;
		Иначе
			C_[i1]=0;
		КонецЕсли;
		Если D >= Степ Тогда
			D=D-Степ;
			D_[i1]=1;
		Иначе
			D_[i1]=0;
		КонецЕсли;
	КонецЦикла;
	Расчет(СтрокаХэш);
	
	A	=	0;
	B	=	0;
	C	=	0;
	D	=	0;
	Для i=1 По 32 Цикл
		Степ=Степень[i];
		Если A_[i]=1 Тогда
			A=A+Степ;	
		КонецЕсли;
		Если B_[i]=1 Тогда
			B=B+Степ;	
		КонецЕсли;
		Если C_[i]=1 Тогда
			C=C+Степ;	
		КонецЕсли;
		Если D_[i]=1 Тогда
			D=D+Степ;	
		КонецЕсли;
	КонецЦикла;
		
	ХэшКод=Из_Число_В_16(A)+Из_Число_В_16(B)+Из_Число_В_16(C)+Из_Число_В_16(D);
	Возврат ХэшКод;
	КонецПопытки;
КонецФункции

Функция Массив(Р)	
	Массив = Новый Массив;
	
	Для Сч=0 по Р Цикл
		Массив.Добавить(0);	
	КонецЦикла;
		
	Возврат Массив;		
КонецФункции

Процедура Тест() Экспорт
		
КонецПроцедуры

Процедура _XOR(П1,П2,Итог)
	Для инд=1 По 32 Цикл
		Если П1[инд] <> П2[инд] Тогда
			Итог[инд]=1;
		Иначе
			Итог[инд]=0;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
//*******************************************
Процедура _AND(П1,П2,Итог)
	Для инд=1 По 32 Цикл
		Если (П1[инд]=1) И (П2[инд]=1) Тогда
			Итог[инд]=1;
		Иначе
			Итог[инд]=0;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
//*******************************************
Процедура _OR(П1,П2,Итог)
	Для инд=1 По 32 Цикл
		Если (П1[инд]=1) ИЛИ (П2[инд]=1) Тогда
			Итог[инд]=1;
		Иначе
			Итог[инд]=0;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
//*******************************************
Процедура _ADD(П1,П2,Итог)
	Добавка=0;
	Для инд=1 По 32 Цикл
		Итог[инд]=П1[инд]+П2[инд]+Добавка;
		Если Итог[инд]=2 Тогда
			Итог[инд]=0;
			Добавка=1;
		ИначеЕсли Итог[инд]=3 Тогда
			Итог[инд]=1;
			Добавка=1;
		Иначе
			Добавка=0;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
//*******************************************
Процедура _NOT(П1,Итог)
	Для инд=1 По 32 Цикл
		Если П1[инд]=0 Тогда
			Итог[инд]=1;
		Иначе
			Итог[инд]=0;	
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
//*******************************************
Процедура _ROL(П1,П2,Итог)
	Для инд=1 По 32 Цикл
		инд1=инд+П2;
		Если инд1 > 32 Тогда
			инд1=инд1-32;
		КонецЕсли;
		Итог[инд1]=П1[инд];
	КонецЦикла;
КонецПроцедуры
//*******************************************
Процедура FF(a,b,c,d,X,s,t)
	_and(b,c,EAX);
	_not(b,EBX);
	_and(EBX,d,ECX);
	_or(EAX,ECX,EBX);
	
	X1=X+t;
	Если X1 >= Stepen32 Тогда
		X1=X1-Stepen32;
	КонецЕсли;
	Для инд=1 По 32 Цикл
		инд1=32-инд+1;
		Степ=Степень[инд1];
		Если X1 >= Степ Тогда
			X1=X1-Степ;
			EDX[инд1]=1;
		Иначе
			EDX[инд1]=0;
		КонецЕсли;
	КонецЦикла;
	_ADD(EBX,a,ECX);
	_ADD(ECX,EDX,EAX);
	
	_rol(EAX,s,ECX);
	_ADD(ECX,b,a);
КонецПроцедуры
//*******************************************
Процедура GG(a,b,c,d,X,s,t)
	_and(b,d,EAX);
	_not(d,EDX);
	_and(EDX,c,ECX);
	_or(EAX,ECX,EBX);
	
	X1=X+t;
	Если X1 >= Stepen32 Тогда
		X1=X1-Stepen32;
	КонецЕсли;
	Для инд=1 По 32 Цикл
		инд1=32-инд+1;
		Степ=Степень[инд1];
		Если X1 >= Степ Тогда
			X1=X1-Степ;
			EDX[инд1]=1;
		Иначе
			EDX[инд1]=0;
		КонецЕсли;
	КонецЦикла;
	_ADD(EBX,a,ECX);
	_ADD(ECX,EDX,EAX);
	
	_rol(EAX,s,ECX);
	_ADD(ECX,b,a);
КонецПроцедуры
//*******************************************
Процедура HH(a,b,c,d,X,s,t)
	_xor(b,c,EAX);
	_xor(EAX,d,EBX);
	
	X1=X+t;
	Если X1 >= Stepen32 Тогда
		X1=X1-Stepen32;
	КонецЕсли;
	Для инд=1 По 32 Цикл
		инд1=32-инд+1;
		Степ=Степень[инд1];
		Если X1 >= Степ Тогда
			X1=X1-Степ;
			EDX[инд1]=1;
		Иначе
			EDX[инд1]=0;
		КонецЕсли;
	КонецЦикла;
	_ADD(EBX,a,ECX);
	_ADD(ECX,EDX,EAX);
	_rol(EAX,s,ECX);
	_ADD(ECX,b,a);
	
КонецПроцедуры
//*******************************************
Процедура II(a,b,c,d,X,s,t)
	_not(d,EAX);
	_or(EAX,b,ECX);
	_xor(ECX,c,EBX);
	
	X1=X+t;
	Если X1 >= Stepen32 Тогда
		X1=X1-Stepen32;
	КонецЕсли;
	Для инд=1 По 32 Цикл
		инд1=32-инд+1;
		Степ=Степень[инд1];
		Если X1 >= Степ Тогда
			X1=X1-Степ;
			EDX[инд1]=1;
		Иначе
			EDX[инд1]=0;
		КонецЕсли;
	КонецЦикла;
	_ADD(EBX,a,ECX);
	_ADD(ECX,EDX,EAX);
	_rol(EAX,s,ECX);
	_ADD(ECX,b,a);
	
КонецПроцедуры
//******************************************************************************
Функция Из_16_В_Число(Знач Значение)
    Результат=0;
	Значение=ВРег(Значение);
	М=1;
    Для Х=1 По 4 Цикл
    	Результат=Результат+(Найти("0123456789ABCDEF",Сред(Значение,2*Х,1))-1)*М;
		М=М*16;
    	Результат=Результат+(Найти("0123456789ABCDEF",Сред(Значение,2*Х-1,1))-1)*М;
		М=М*16;
    КонецЦикла;
    Возврат Результат;
КонецФункции
//*******************************************
Функция Из_Число_В_16(Знач Значение)
	Результат="";
	Для инд=1 По 4 Цикл
		Остат=Значение%16+1;
		Результат1=Сред("0123456789ABCDEF",Остат,1);
		Значение=Цел(Значение/16);
		Остат=Значение%16+1;
		Результат2=Сред("0123456789ABCDEF",Остат,1);
		Значение=Цел(Значение/16);
		Результат=Результат+Результат2+Результат1;
	КонецЦикла;
    Возврат Результат;
КонецФункции
//*******************************************
Процедура MD5Hash()
Перем A1,B1,C1,D1;

	A1 = Массив(32);
	B1 = Массив(32);
	C1 = Массив(32);
	D1 = Массив(32);

	Для i=1 По 32 Цикл
		A1[i]	=	A_[i];
		B1[i]	=	B_[i];
		C1[i]	=	C_[i];
		D1[i]	=	D_[i];
	КонецЦикла;
	
// --------------------------------------------------------------------------
// Round 1.
// --------------------------------------------------------------------------
                        FF      (a_,b_,c_,d_, X[1], S11, 3614090360)  ;// Step 1
                        FF      (d_,a_,b_,c_, X[2], S12, 3905402710)  ;// Step 2
                        FF      (c_,d_,a_,b_, X[3], S13,  606105819)  ;// Step 3
                        FF      (b_,c_,d_,a_, X[4], S14, 3250441966)  ;// Step 4
                        FF      (a_,b_,c_,d_, X[5], S11, 4118548399)  ;// Step 5
                        FF      (d_,a_,b_,c_, X[6], S12, 1200080426)  ;// Step 6
                        FF      (c_,d_,a_,b_, X[7], S13, 2821735955)  ;// Step 7
                        FF      (b_,c_,d_,a_, X[8], S14, 4249261313)  ;// Step 8
                        FF      (a_,b_,c_,d_, X[9], S11, 1770035416)  ;// Step 9
                        FF      (d_,a_,b_,c_, X[10],S12, 2336552879)  ;// Step 10
                        FF      (c_,d_,a_,b_, X[11],S13, 4294925233)  ;// Step 11
                        FF      (b_,c_,d_,a_, X[12],S14, 2304563134)  ;// Step 12
                        FF      (a_,b_,c_,d_, X[13],S11, 1804603682)  ;// Step 13
                        FF      (d_,a_,b_,c_, X[14],S12, 4254626195)  ;// Step 14
                        FF      (c_,d_,a_,b_, X[15],S13, 2792965006)  ;// Step 15
                        FF      (b_,c_,d_,a_, X[16],S14, 1236535329)  ;// Step 16
// --------------------------------------------------------------------------
// Round 2.
// --------------------------------------------------------------------------
                        GG      (a_,b_,c_,d_, X[2], S21, 4129170786)  ;// Step 17
                        GG      (d_,a_,b_,c_, X[7], S22, 3225465664)  ;// Step 18
                        GG      (c_,d_,a_,b_, X[12],S23,  643717713)  ;// Step 19
                        GG      (b_,c_,d_,a_, X[1], S24, 3921069994)  ;// Step 20
                        GG      (a_,b_,c_,d_, X[6], S21, 3593408605)  ;// Step 21
                        GG      (d_,a_,b_,c_, X[11],S22,   38016083)  ;// Step 22 
                        GG      (c_,d_,a_,b_, X[16],S23, 3634488961)  ;// Step 23
                        GG      (b_,c_,d_,a_, X[5], S24, 3889429448)  ;// Step 24
                        GG      (a_,b_,c_,d_, X[10],S21,  568446438)  ;// Step 25
                        GG      (d_,a_,b_,c_, X[15],S22, 3275163606)  ;// Step 26
                        GG      (c_,d_,a_,b_, X[4], S23, 4107603335)  ;// Step 27
                        GG      (b_,c_,d_,a_, X[9], S24, 1163531501)  ;// Step 28
                        GG      (a_,b_,c_,d_, X[14],S21, 2850285829)  ;// Step 29
                        GG      (d_,a_,b_,c_, X[3], S22, 4243563512)  ;// Step 30
                        GG      (c_,d_,a_,b_, X[8], S23, 1735328473)  ;// Step 31
                        GG      (b_,c_,d_,a_, X[13],S24, 2368359562)  ;// Step 32
// --------------------------------------------------------------------------
// Round 3.
// --------------------------------------------------------------------------
                        HH      (a_,b_,c_,d_, X[6], S31, 4294588738)  ;// Step 33
                        HH      (d_,a_,b_,c_, X[9], S32, 2272392833)  ;// Step 34
                        HH      (c_,d_,a_,b_, X[12],S33, 1839030562)  ;// Step 35
                        HH      (b_,c_,d_,a_, X[15],S34, 4259657740)  ;// Step 36
                        HH      (a_,b_,c_,d_, X[2], S31, 2763975236)  ;// Step 37
                        HH      (d_,a_,b_,c_, X[5], S32, 1272893353)  ;// Step 38
                        HH      (c_,d_,a_,b_, X[8], S33, 4139469664)  ;// Step 39
                        HH      (b_,c_,d_,a_, X[11],S34, 3200236656)  ;// Step 40
                        HH      (a_,b_,c_,d_, X[14],S31,  681279174)  ;// Step 41
                        HH      (d_,a_,b_,c_, X[1], S32, 3936430074)  ;// Step 42
                        HH      (c_,d_,a_,b_, X[4], S33, 3572445317)  ;// Step 43
                        HH      (b_,c_,d_,a_, X[7], S34,   76029189)  ;// Step 44
                        HH      (a_,b_,c_,d_, X[10],S31, 3654602809)  ;// Step 45
                        HH      (d_,a_,b_,c_, X[13],S32, 3873151461)  ;// Step 46
                        HH      (c_,d_,a_,b_, X[16],S33,  530742520)  ;// Step 47
                        HH      (b_,c_,d_,a_, X[3], S34, 3299628645)  ;// Step 48
// --------------------------------------------------------------------------
// Round 4.
// --------------------------------------------------------------------------
                        II      (a_,b_,c_,d_, X[1], S41, 4096336452)  ;// Step 49
                        II      (d_,a_,b_,c_, X[8], S42, 1126891415)  ;// Step 50
                        II      (c_,d_,a_,b_, X[15],S43, 2878612391)  ;// Step 51
                        II      (b_,c_,d_,a_, X[6], S44, 4237533241)  ;// Step 52
                        II      (a_,b_,c_,d_, X[13],S41, 1700485571)  ;// Step 53
                        II      (d_,a_,b_,c_, X[4], S42, 2399980690)  ;// Step 54
                        II      (c_,d_,a_,b_, X[11],S43, 4293915773)  ;// Step 55
                        II      (b_,c_,d_,a_, X[2], S44, 2240044497)  ;// Step 56
                        II      (a_,b_,c_,d_, X[9], S41, 1873313359)  ;// Step 57
                        II      (d_,a_,b_,c_, X[16],S42, 4264355552)  ;// Step 58
                        II      (c_,d_,a_,b_, X[7], S43, 2734768916)  ;// Step 59
                        II      (b_,c_,d_,a_, X[14],S44, 1309151649)  ;// Step 60
                        II      (a_,b_,c_,d_, X[5], S41, 4149444226)  ;// Step 61
                        II      (d_,a_,b_,c_, X[12],S42, 3174756917)  ;// Step 62
                        II      (c_,d_,a_,b_, X[3], S43,  718787259)  ;// Step 63
                        II      (b_,c_,d_,a_, X[10],S44, 3951481745)  ;// Step 64
// --------------------------------------------------------------------------
    
	_ADD(A_,A1,A_);
	_ADD(B_,B1,B_);
	_ADD(C_,C1,C_);
	_ADD(D_,D1,D_);
КонецПроцедуры
//*******************************************
Процедура Расчет(Стр,Длина=0)
	Перем Мас;
	
	Мас = Массив(64);
	
	Если Длина=0 Тогда
		Длина=СтрДлина(Стр);
	КонецЕсли;
	
	// Определение Хэш кодов 64 байтных блоков
	ДлСтр=СтрДлина(Стр);
	Пока ДлСтр >= 64 Цикл
		i1=0;
		Для i = 1 По 16 Цикл
			X[i]=КодСимвола(Сред(Стр,i1+1,1))+
			КодСимвола(Сред(Стр,i1+2,1))*256+
			КодСимвола(Сред(Стр,i1+3,1))*65536+
			КодСимвола(Сред(Стр,i1+4,1))*16777216;
			i1=i1+4;
		КонецЦикла;
		MD5Hash();
		Стр=Сред(Стр,65);
		ДлСтр=СтрДлина(Стр);
	КонецЦикла;
	
	// Финал - определение Хэш кода последнего блока
	Если Длина <> -1 Тогда  // Если Длина=-1 то значит это не последний блок
		ДлинаБит=Длина*8;
		Для i = 1 По ДлСтр Цикл 
			Мас[i]=КодСимвола(Сред(Стр,i,1));
		КонецЦикла;
		Мас[ДлСтр+1]=128;
		Длина=ДлСтр+1;
		
		// В последнем блоке нет свободных 8 байт для длины
		// Дополняем блок до 64 байт
		Если Длина > 56 Тогда
			Для i = Длина+1 По 64 Цикл
				Мас[i]=0;
			КонецЦикла; 
			i1=0;
			Для i = 1 По 16 Цикл
				X[i]=Мас[i1+1]+
				Мас[i1+2]*256+
				Мас[i1+3]*65536+
				Мас[i1+4]*16777216;
				i1=i1+4;
			КонецЦикла;
			MD5Hash();
			Длина=0;
		КонецЕсли;
		
		// Дополняем блок до 56 байт и заносим длину в битах
		Для i = Длина+1 По 56 Цикл
			Мас[i]=0;
		КонецЦикла;
		i1=0;
		Для i = 1 По 14 Цикл
			X[i]=Мас[i1+1]+
			Мас[i1+2]*256+
			Мас[i1+3]*65536+
			Мас[i1+4]*16777216;
			i1=i1+4;
		КонецЦикла;
		X[15]=ДлинаБит%Stepen32;
		X[16]=Цел(ДлинаБит/Stepen32);
		MD5Hash();
	КонецЕсли;
	
КонецПроцедуры
//*******************************************

Функция MD5Script(КодируемаяСтрока)
	
	Экспорт
	
    //http://pajhome.org.uk/crypt/md5/index.html
	
  	lx_ScrptCtrl = Новый COMОбъект("MSScriptControl.ScriptControl");
	lx_ScrptCtrl.Language = "JScript";
	lx_ScrptCtrl.AddCode(
	"var hexcase = 0;  /* hex output format. 0 - lowercase; 1 - uppercase        */
	|var b64pad  = """"; /* base-64 pad character. ""="" for strict RFC compliance   */ 
	|var chrsz   = 8;  /* bits per input character. 8 - ASCII; 16 - Unicode      */
	|function hex_md5(s){ return binl2hex(core_md5(str2binl(s), s.length * chrsz));}
	|function b64_md5(s){ return binl2b64(core_md5(str2binl(s), s.length * chrsz));}
	|function str_md5(s){ return binl2str(core_md5(str2binl(s), s.length * chrsz));}
	|function hex_hmac_md5(key, data) { return binl2hex(core_hmac_md5(key, data)); }
	|function b64_hmac_md5(key, data) { return binl2b64(core_hmac_md5(key, data)); }
	|function str_hmac_md5(key, data) { return binl2str(core_hmac_md5(key, data)); }
	|
	|function preg_replace(s, regs, flag, sreplace) { 
	|	var reg = new RegExp(regs, flag);
	|	return s.replace(reg, sreplace);
	|}
	|
	//|function preg_translit(s) { 
	//|	$_ = s;
	//|	tr/АВСЕОТРКХНМ/ABCEOTPKXHM/d;
	//|	return $_;
	//|}
	//|
	//|function preg_translit(s, st1, st2, flag) { 
	//|	$_ = s;
	//|	eval ""tr/"" + st1 + ""/"" + st2 + ""/"" + flag + "";
	//|	return $_;
	//|}
	//|
	|function md5_vm_test()
	|{
	|  return hex_md5(""abc"") == ""900150983cd24fb0d6963f7d28e17f72"";
	|}
	|function core_md5(x, len)
	|{
	|  x[len >> 5] |= 0x80 << ((len) % 32);
	|  x[(((len + 64) >>> 9) << 4) + 14] = len;
	|
	|  var a =  1732584193;
	|  var b = -271733879;
	|  var c = -1732584194;
	|  var d =  271733878;
	|
	|  for(var i = 0; i < x.length; i += 16)
	|  {
	|    var olda = a;
	|    var oldb = b;
	|    var oldc = c;
	|    var oldd = d;
	|
	|    a = md5_ff(a, b, c, d, x[i+ 0], 7 , -680876936);
	|    d = md5_ff(d, a, b, c, x[i+ 1], 12, -389564586);
	|    c = md5_ff(c, d, a, b, x[i+ 2], 17,  606105819);
	|    b = md5_ff(b, c, d, a, x[i+ 3], 22, -1044525330);
	|    a = md5_ff(a, b, c, d, x[i+ 4], 7 , -176418897);
	|    d = md5_ff(d, a, b, c, x[i+ 5], 12,  1200080426);
	|    c = md5_ff(c, d, a, b, x[i+ 6], 17, -1473231341);
	|    b = md5_ff(b, c, d, a, x[i+ 7], 22, -45705983);
	|    a = md5_ff(a, b, c, d, x[i+ 8], 7 ,  1770035416);
	|    d = md5_ff(d, a, b, c, x[i+ 9], 12, -1958414417);
	|    c = md5_ff(c, d, a, b, x[i+10], 17, -42063);
	|    b = md5_ff(b, c, d, a, x[i+11], 22, -1990404162);
	|    a = md5_ff(a, b, c, d, x[i+12], 7 ,  1804603682);
	|    d = md5_ff(d, a, b, c, x[i+13], 12, -40341101);
	|    c = md5_ff(c, d, a, b, x[i+14], 17, -1502002290);
	|    b = md5_ff(b, c, d, a, x[i+15], 22,  1236535329);
	|
	|    a = md5_gg(a, b, c, d, x[i+ 1], 5 , -165796510);
	|    d = md5_gg(d, a, b, c, x[i+ 6], 9 , -1069501632);
	|    c = md5_gg(c, d, a, b, x[i+11], 14,  643717713);
	|    b = md5_gg(b, c, d, a, x[i+ 0], 20, -373897302);
	|    a = md5_gg(a, b, c, d, x[i+ 5], 5 , -701558691);
	|    d = md5_gg(d, a, b, c, x[i+10], 9 ,  38016083);
	|    c = md5_gg(c, d, a, b, x[i+15], 14, -660478335);
	|    b = md5_gg(b, c, d, a, x[i+ 4], 20, -405537848);
	|    a = md5_gg(a, b, c, d, x[i+ 9], 5 ,  568446438);
	|    d = md5_gg(d, a, b, c, x[i+14], 9 , -1019803690);
	|    c = md5_gg(c, d, a, b, x[i+ 3], 14, -187363961);
	|    b = md5_gg(b, c, d, a, x[i+ 8], 20,  1163531501);
	|    a = md5_gg(a, b, c, d, x[i+13], 5 , -1444681467);
	|    d = md5_gg(d, a, b, c, x[i+ 2], 9 , -51403784);
	|    c = md5_gg(c, d, a, b, x[i+ 7], 14,  1735328473);
	|    b = md5_gg(b, c, d, a, x[i+12], 20, -1926607734);
	|
	|    a = md5_hh(a, b, c, d, x[i+ 5], 4 , -378558);
	|    d = md5_hh(d, a, b, c, x[i+ 8], 11, -2022574463);
	|    c = md5_hh(c, d, a, b, x[i+11], 16,  1839030562);
	|    b = md5_hh(b, c, d, a, x[i+14], 23, -35309556);
	|    a = md5_hh(a, b, c, d, x[i+ 1], 4 , -1530992060);
	|    d = md5_hh(d, a, b, c, x[i+ 4], 11,  1272893353);
	|    c = md5_hh(c, d, a, b, x[i+ 7], 16, -155497632);
	|    b = md5_hh(b, c, d, a, x[i+10], 23, -1094730640);
	|    a = md5_hh(a, b, c, d, x[i+13], 4 ,  681279174);
	|    d = md5_hh(d, a, b, c, x[i+ 0], 11, -358537222);
	|    c = md5_hh(c, d, a, b, x[i+ 3], 16, -722521979);
	|    b = md5_hh(b, c, d, a, x[i+ 6], 23,  76029189);
	|    a = md5_hh(a, b, c, d, x[i+ 9], 4 , -640364487);
	|    d = md5_hh(d, a, b, c, x[i+12], 11, -421815835);
	|    c = md5_hh(c, d, a, b, x[i+15], 16,  530742520);
	|    b = md5_hh(b, c, d, a, x[i+ 2], 23, -995338651);
	|
	|    a = md5_ii(a, b, c, d, x[i+ 0], 6 , -198630844);
	|    d = md5_ii(d, a, b, c, x[i+ 7], 10,  1126891415);
	|    c = md5_ii(c, d, a, b, x[i+14], 15, -1416354905);
	|    b = md5_ii(b, c, d, a, x[i+ 5], 21, -57434055);
	|    a = md5_ii(a, b, c, d, x[i+12], 6 ,  1700485571);
	|    d = md5_ii(d, a, b, c, x[i+ 3], 10, -1894986606);
	|    c = md5_ii(c, d, a, b, x[i+10], 15, -1051523);
	|    b = md5_ii(b, c, d, a, x[i+ 1], 21, -2054922799);
	|    a = md5_ii(a, b, c, d, x[i+ 8], 6 ,  1873313359);
	|    d = md5_ii(d, a, b, c, x[i+15], 10, -30611744);
	|    c = md5_ii(c, d, a, b, x[i+ 6], 15, -1560198380);
	|    b = md5_ii(b, c, d, a, x[i+13], 21,  1309151649);
	|    a = md5_ii(a, b, c, d, x[i+ 4], 6 , -145523070);
	|    d = md5_ii(d, a, b, c, x[i+11], 10, -1120210379);
	|    c = md5_ii(c, d, a, b, x[i+ 2], 15,  718787259);
	|    b = md5_ii(b, c, d, a, x[i+ 9], 21, -343485551);
	|
	|    a = safe_add(a, olda);
	|    b = safe_add(b, oldb);
	|    c = safe_add(c, oldc);
	|    d = safe_add(d, oldd);
	|  }
	|  return Array(a, b, c, d);
	|
	|}
	|
	|function md5_cmn(q, a, b, x, s, t)
	|{
	|  return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s),b);
	|}
	|function md5_ff(a, b, c, d, x, s, t)
	|{
	|  return md5_cmn((b & c) | ((~b) & d), a, b, x, s, t);
	|}
	|function md5_gg(a, b, c, d, x, s, t)
	|{
	|  return md5_cmn((b & d) | (c & (~d)), a, b, x, s, t);
	|}
	|function md5_hh(a, b, c, d, x, s, t)
	|{
	|  return md5_cmn(b ^ c ^ d, a, b, x, s, t);
	|}
	|function md5_ii(a, b, c, d, x, s, t)
	|{
	|  return md5_cmn(c ^ (b | (~d)), a, b, x, s, t);
	|}
	|
	|function core_hmac_md5(key, data)
	|{
	|  var bkey = str2binl(key);
	|  if(bkey.length > 16) bkey = core_md5(bkey, key.length * chrsz);
	|
	|  var ipad = Array(16), opad = Array(16);
	|  for(var i = 0; i < 16; i++)
	|  {
	|    ipad[i] = bkey[i] ^ 0x36363636;
	|    opad[i] = bkey[i] ^ 0x5C5C5C5C;
	|  }
	|
	|  var hash = core_md5(ipad.concat(str2binl(data)), 512 + data.length * chrsz);
	|  return core_md5(opad.concat(hash), 512 + 128);
	|}
	|
	|function safe_add(x, y)
	|{
	|  var lsw = (x & 0xFFFF) + (y & 0xFFFF);
	|  var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
	|  return (msw << 16) | (lsw & 0xFFFF);
	|}
	|
	|/*
	| * Bitwise rotate a 32-bit number to the left.
	| */
	|function bit_rol(num, cnt)
	|{
	|  return (num << cnt) | (num >>> (32 - cnt));
	|}
	|
	|/*
	| * Convert a string to an array of little-endian words
	| * If chrsz is ASCII, characters >255 have their hi-byte silently ignored.
	| */
	|function str2binl(str)
	|{
	|  var bin = Array();
	|  var mask = (1 << chrsz) - 1;
	|  for(var i = 0; i < str.length * chrsz; i += chrsz)
	|    bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (i%32);
	|  return bin;
	|}
	|
	|function binl2str(bin)
	|{
	|  var str = """";
	|  var mask = (1 << chrsz) - 1;
	|  for(var i = 0; i < bin.length * 32; i += chrsz)
	|    str += String.fromCharCode((bin[i>>5] >>> (i % 32)) & mask);
	|  return str;
	|}
	|
	|function binl2hex(binarray)
	|{
	|  var hex_tab = hexcase ? ""0123456789ABCDEF"" : ""0123456789abcdef"";
	|  var str = """";
	|  for(var i = 0; i < binarray.length * 4; i++)
	|  {
	|    str += hex_tab.charAt((binarray[i>>2] >> ((i%4)*8+4)) & 0xF) +
	|           hex_tab.charAt((binarray[i>>2] >> ((i%4)*8  )) & 0xF);
	|  }
	|  return str;
	|}
	|
	|function binl2b64(binarray)
	|{
	|  var tab = ""ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"";
	|  var str = """";
	|  for(var i = 0; i < binarray.length * 4; i += 3)
	|  {
	|    var triplet = (((binarray[i   >> 2] >> 8 * ( i   %4)) & 0xFF) << 16)
	|                | (((binarray[i+1 >> 2] >> 8 * ((i+1)%4)) & 0xFF) << 8 )
	|                |  ((binarray[i+2 >> 2] >> 8 * ((i+2)%4)) & 0xFF);
	|    for(var j = 0; j < 4; j++)
	|    {
	|      if(i * 8 + j * 6 > binarray.length * 32) str += b64pad;
	|      else str += tab.charAt((triplet >> 6*(3-j)) & 0x3F);
	|    }
	|  }
	|  return str;
	|}
	|");
	


	Хэш = lx_ScrptCtrl.Run("hex_md5", КодируемаяСтрока);
	Возврат Хэш;
КонецФункции // MD5()

Функция DecToHex(Знач Число) 
    Если Число = 0 Тогда Возврат "00"; КонецЕсли; 
    _Число = Число;
    База = 16;
    Пока _Число <> 0 Цикл
        Поз =_Число % База;
        Результат = Сред("0123456789abcdef", Поз + 1, 1) + Результат;
        _Число = Цел(_Число / База);
    КонецЦикла;
    Если Число < База Тогда Результат = "0" + Результат; КонецЕсли; 
    Возврат Результат;
КонецФункции // DecToHex()

Функция MD5Win(КодируемаяСтрока) Экспорт
	
	UTF8 = Новый COMОбъект("System.Text.UTF8Encoding");
	Crypt = Новый COMОбъект("System.Security.Cryptography.MD5CryptoServiceProvider");
	HashArray = Crypt.ComputeHash_2(UTF8.GetBytes_4(КодируемаяСтрока));
	
	Хэш = "";
	Для каждого Число Из HashArray Цикл
	    Хэш = Хэш + DecToHex(Число);
	КонецЦикла;
	
	Возврат Хэш;
	
КонецФункции




	