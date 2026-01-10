#!/usr/bin/env node

'use strict';

const path = require('path');
const { createWorker } = require('../..');

const [,, imagePath] = process.argv;
// 指定识别的图像文件路径
const image = path.resolve(__dirname, (imagePath || '../../images/tb55.png'));

console.log(`Recognizing ${image}`);
// 初始化Tesseract.js识别引擎
(async () => {
  // 指定藏文语言包'bod'，使用1个工作线程
  const worker = await createWorker('bod', 1, {
    logger: (m) => console.log(m),
  });
  const { data: { text } } = await worker.recognize(image);
  console.log(text);
  await worker.terminate();
})();
