# zhuyin_app


2025.06.13
- Succesfully upload images
- Successfully connect it to using Google Cloud Vision API to recognize chinese image 

-> Have error in converting it to zhuyin (need to check whether taiwan has big data from word to zhuyin)
-> edit the ui interface 


中文轉拼音 (注音)
Resources
- https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/respub/dict_reviseddict_download.html
- dict_revised_2015_20250327	文字資料庫
- utilize github : https://github.com/g0v/moedict-data
- 記得加教育部版權 (Maybe I can fork the github up )

2025.06.21
Image to zhuyin done!
![image](https://github.com/user-attachments/assets/c515fef1-0b60-4690-86cb-43a51ba4e907)

Next Step : Change UI. delete the 照相. Instead add typing (text) to zhuyin.
Check 版權問題, API Key Security

Get rid of the dictionary Iｕｓｅｄ，　ｇｅｔ　ｒｉｄ　ｏｆ　ａｐｉ　ｋｅｙ, give right to owner, 


Zhuyin_transform/zhuyin_dict.json 使用著「重編國語辭典（修訂本）」的公眾授權內容。辭典本文的著作權仍為教育部所有。（不公開）

公眾授權網：https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/respub/index.html

依教育部之解釋，「創用CC-姓名標示- 禁止改作 臺灣3.0版授權條款」之改作限制標的為文字資料本身，不限制格式轉換及後續應用。

=====================================================
企劃執行：國家教育研究院

原 著 者：教育部國語推行委員會
　　　   （民國102年1月1日配合行政院組改併入相關單位）

發 行 人：潘文忠　林崇熙

發 行 所：中華民國教育部

維護單位：國家教育研究院語文教育及編譯研究中心

地　　址：臺北市大安區和平東路一段179號

電　　話：(02)7740-7282

傳　　真：(02)7740-7284

電子郵件：onile@mail.naer.edu.tw

版　　次：中華民國110年11月臺灣學術網路第六版
=====================================================
此處轉換格式、重新編排的編輯著作權（如果有的話）由 @kcwu 以 CC0 釋出。