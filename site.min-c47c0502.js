(()=>{var e={802:e=>{function n(e){return e instanceof Map?e.clear=e.delete=e.set=function(){throw new Error("map is read-only")}:e instanceof Set&&(e.add=e.clear=e.delete=function(){throw new Error("set is read-only")}),Object.freeze(e),Object.getOwnPropertyNames(e).forEach((function(t){var a=e[t];"object"!=typeof a||Object.isFrozen(a)||n(a)})),e}var t=n,a=n;t.default=a;class i{constructor(e){void 0===e.data&&(e.data={}),this.data=e.data}ignoreMatch(){this.ignore=!0}}function s(e){return e.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").replace(/'/g,"&#x27;")}function r(e,...n){const t=Object.create(null);for(const n in e)t[n]=e[n];return n.forEach((function(e){for(const n in e)t[n]=e[n]})),t}const o=e=>!!e.kind;class l{constructor(e,n){this.buffer="",this.classPrefix=n.classPrefix,e.walk(this)}addText(e){this.buffer+=s(e)}openNode(e){if(!o(e))return;let n=e.kind;e.sublanguage||(n=`${this.classPrefix}${n}`),this.span(n)}closeNode(e){o(e)&&(this.buffer+="</span>")}value(){return this.buffer}span(e){this.buffer+=`<span class="${e}">`}}class c{constructor(){this.rootNode={children:[]},this.stack=[this.rootNode]}get top(){return this.stack[this.stack.length-1]}get root(){return this.rootNode}add(e){this.top.children.push(e)}openNode(e){const n={kind:e,children:[]};this.add(n),this.stack.push(n)}closeNode(){if(this.stack.length>1)return this.stack.pop()}closeAllNodes(){for(;this.closeNode(););}toJSON(){return JSON.stringify(this.rootNode,null,4)}walk(e){return this.constructor._walk(e,this.rootNode)}static _walk(e,n){return"string"==typeof n?e.addText(n):n.children&&(e.openNode(n),n.children.forEach((n=>this._walk(e,n))),e.closeNode(n)),e}static _collapse(e){"string"!=typeof e&&e.children&&(e.children.every((e=>"string"==typeof e))?e.children=[e.children.join("")]:e.children.forEach((e=>{c._collapse(e)})))}}class u extends c{constructor(e){super(),this.options=e}addKeyword(e,n){""!==e&&(this.openNode(n),this.addText(e),this.closeNode())}addText(e){""!==e&&this.add(e)}addSublanguage(e,n){const t=e.root;t.kind=n,t.sublanguage=!0,this.add(t)}toHTML(){return new l(this,this.options).value()}finalize(){return!0}}function g(e){return e?"string"==typeof e?e:e.source:null}const d="[a-zA-Z]\\w*",h="[a-zA-Z_]\\w*",f="\\b\\d+(\\.\\d+)?",b="(-?)(\\b0[xX][a-fA-F0-9]+|(\\b\\d+(\\.\\d*)?|\\.\\d+)([eE][-+]?\\d+)?)",m="\\b(0b[01]+)",p={begin:"\\\\[\\s\\S]",relevance:0},E={className:"string",begin:"'",end:"'",illegal:"\\n",contains:[p]},v={className:"string",begin:'"',end:'"',illegal:"\\n",contains:[p]},w={begin:/\b(a|an|the|are|I'm|isn't|don't|doesn't|won't|but|just|should|pretty|simply|enough|gonna|going|wtf|so|such|will|you|your|they|like|more)\b/},x=function(e,n,t={}){const a=r({className:"comment",begin:e,end:n,contains:[]},t);return a.contains.push(w),a.contains.push({className:"doctag",begin:"(?:TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):",relevance:0}),a},N=x("//","$"),_=x("/\\*","\\*/"),y=x("#","$"),R={className:"number",begin:f,relevance:0},A={className:"number",begin:b,relevance:0},L={className:"number",begin:m,relevance:0},k={className:"number",begin:f+"(%|em|ex|ch|rem|vw|vh|vmin|vmax|cm|mm|in|pt|pc|px|deg|grad|rad|turn|s|ms|Hz|kHz|dpi|dpcm|dppx)?",relevance:0},M={begin:/(?=\/[^/\n]*\/)/,contains:[{className:"regexp",begin:/\//,end:/\/[gimuy]*/,illegal:/\n/,contains:[p,{begin:/\[/,end:/\]/,relevance:0,contains:[p]}]}]},S={className:"title",begin:d,relevance:0},O={className:"title",begin:h,relevance:0};var B=Object.freeze({__proto__:null,MATCH_NOTHING_RE:/\b\B/,IDENT_RE:d,UNDERSCORE_IDENT_RE:h,NUMBER_RE:f,C_NUMBER_RE:b,BINARY_NUMBER_RE:m,RE_STARTERS_RE:"!|!=|!==|%|%=|&|&&|&=|\\*|\\*=|\\+|\\+=|,|-|-=|/=|/|:|;|<<|<<=|<=|<|===|==|=|>>>=|>>=|>=|>>>|>>|>|\\?|\\[|\\{|\\(|\\^|\\^=|\\||\\|=|\\|\\||~",SHEBANG:(e={})=>{const n=/^#![ ]*\//;return e.binary&&(e.begin=function(...e){return e.map((e=>g(e))).join("")}(n,/.*\b/,e.binary,/\b.*/)),r({className:"meta",begin:n,end:/$/,relevance:0,"on:begin":(e,n)=>{0!==e.index&&n.ignoreMatch()}},e)},BACKSLASH_ESCAPE:p,APOS_STRING_MODE:E,QUOTE_STRING_MODE:v,PHRASAL_WORDS_MODE:w,COMMENT:x,C_LINE_COMMENT_MODE:N,C_BLOCK_COMMENT_MODE:_,HASH_COMMENT_MODE:y,NUMBER_MODE:R,C_NUMBER_MODE:A,BINARY_NUMBER_MODE:L,CSS_NUMBER_MODE:k,REGEXP_MODE:M,TITLE_MODE:S,UNDERSCORE_TITLE_MODE:O,METHOD_GUARD:{begin:"\\.\\s*[a-zA-Z_]\\w*",relevance:0},END_SAME_AS_BEGIN:function(e){return Object.assign(e,{"on:begin":(e,n)=>{n.data._beginMatch=e[1]},"on:end":(e,n)=>{n.data._beginMatch!==e[1]&&n.ignoreMatch()}})}});function T(e,n){"."===e.input[e.index-1]&&n.ignoreMatch()}function I(e,n){n&&e.beginKeywords&&(e.begin="\\b("+e.beginKeywords.split(" ").join("|")+")(?!\\.)(?=\\b|\\s)",e.__beforeBegin=T,e.keywords=e.keywords||e.beginKeywords,delete e.beginKeywords,void 0===e.relevance&&(e.relevance=0))}function D(e,n){Array.isArray(e.illegal)&&(e.illegal=function(...e){return"("+e.map((e=>g(e))).join("|")+")"}(...e.illegal))}function C(e,n){if(e.match){if(e.begin||e.end)throw new Error("begin & end are not supported with match");e.begin=e.match,delete e.match}}function P(e,n){void 0===e.relevance&&(e.relevance=1)}const j=["of","and","for","in","not","or","if","then","parent","list","value"];function $(e,n,t="keyword"){const a={};return"string"==typeof e?i(t,e.split(" ")):Array.isArray(e)?i(t,e):Object.keys(e).forEach((function(t){Object.assign(a,$(e[t],n,t))})),a;function i(e,t){n&&(t=t.map((e=>e.toLowerCase()))),t.forEach((function(n){const t=n.split("|");a[t[0]]=[e,H(t[0],t[1])]}))}}function H(e,n){return n?Number(n):function(e){return j.includes(e.toLowerCase())}(e)?0:1}function q(e,{plugins:n}){function t(n,t){return new RegExp(g(n),"m"+(e.case_insensitive?"i":"")+(t?"g":""))}class a{constructor(){this.matchIndexes={},this.regexes=[],this.matchAt=1,this.position=0}addRule(e,n){n.position=this.position++,this.matchIndexes[this.matchAt]=n,this.regexes.push([n,e]),this.matchAt+=function(e){return new RegExp(e.toString()+"|").exec("").length-1}(e)+1}compile(){0===this.regexes.length&&(this.exec=()=>null);const e=this.regexes.map((e=>e[1]));this.matcherRe=t(function(e,n="|"){const t=/\[(?:[^\\\]]|\\.)*\]|\(\??|\\([1-9][0-9]*)|\\./;let a=0,i="";for(let s=0;s<e.length;s++){a+=1;const r=a;let o=g(e[s]);for(s>0&&(i+=n),i+="(";o.length>0;){const e=t.exec(o);if(null==e){i+=o;break}i+=o.substring(0,e.index),o=o.substring(e.index+e[0].length),"\\"===e[0][0]&&e[1]?i+="\\"+String(Number(e[1])+r):(i+=e[0],"("===e[0]&&a++)}i+=")"}return i}(e),!0),this.lastIndex=0}exec(e){this.matcherRe.lastIndex=this.lastIndex;const n=this.matcherRe.exec(e);if(!n)return null;const t=n.findIndex(((e,n)=>n>0&&void 0!==e)),a=this.matchIndexes[t];return n.splice(0,t),Object.assign(n,a)}}class i{constructor(){this.rules=[],this.multiRegexes=[],this.count=0,this.lastIndex=0,this.regexIndex=0}getMatcher(e){if(this.multiRegexes[e])return this.multiRegexes[e];const n=new a;return this.rules.slice(e).forEach((([e,t])=>n.addRule(e,t))),n.compile(),this.multiRegexes[e]=n,n}resumingScanAtSamePosition(){return 0!==this.regexIndex}considerAll(){this.regexIndex=0}addRule(e,n){this.rules.push([e,n]),"begin"===n.type&&this.count++}exec(e){const n=this.getMatcher(this.regexIndex);n.lastIndex=this.lastIndex;let t=n.exec(e);if(this.resumingScanAtSamePosition())if(t&&t.index===this.lastIndex);else{const n=this.getMatcher(0);n.lastIndex=this.lastIndex+1,t=n.exec(e)}return t&&(this.regexIndex+=t.position+1,this.regexIndex===this.count&&this.considerAll()),t}}if(e.compilerExtensions||(e.compilerExtensions=[]),e.contains&&e.contains.includes("self"))throw new Error("ERR: contains `self` is not supported at the top-level of a language.  See documentation.");return e.classNameAliases=r(e.classNameAliases||{}),function n(a,s){const o=a;if(a.compiled)return o;[C].forEach((e=>e(a,s))),e.compilerExtensions.forEach((e=>e(a,s))),a.__beforeBegin=null,[I,D,P].forEach((e=>e(a,s))),a.compiled=!0;let l=null;if("object"==typeof a.keywords&&(l=a.keywords.$pattern,delete a.keywords.$pattern),a.keywords&&(a.keywords=$(a.keywords,e.case_insensitive)),a.lexemes&&l)throw new Error("ERR: Prefer `keywords.$pattern` to `mode.lexemes`, BOTH are not allowed. (see mode reference) ");return l=l||a.lexemes||/\w+/,o.keywordPatternRe=t(l,!0),s&&(a.begin||(a.begin=/\B|\b/),o.beginRe=t(a.begin),a.endSameAsBegin&&(a.end=a.begin),a.end||a.endsWithParent||(a.end=/\B|\b/),a.end&&(o.endRe=t(a.end)),o.terminatorEnd=g(a.end)||"",a.endsWithParent&&s.terminatorEnd&&(o.terminatorEnd+=(a.end?"|":"")+s.terminatorEnd)),a.illegal&&(o.illegalRe=t(a.illegal)),a.contains||(a.contains=[]),a.contains=[].concat(...a.contains.map((function(e){return function(e){return e.variants&&!e.cachedVariants&&(e.cachedVariants=e.variants.map((function(n){return r(e,{variants:null},n)}))),e.cachedVariants?e.cachedVariants:z(e)?r(e,{starts:e.starts?r(e.starts):null}):Object.isFrozen(e)?r(e):e}("self"===e?a:e)}))),a.contains.forEach((function(e){n(e,o)})),a.starts&&n(a.starts,s),o.matcher=function(e){const n=new i;return e.contains.forEach((e=>n.addRule(e.begin,{rule:e,type:"begin"}))),e.terminatorEnd&&n.addRule(e.terminatorEnd,{type:"end"}),e.illegal&&n.addRule(e.illegal,{type:"illegal"}),n}(o),o}(e)}function z(e){return!!e&&(e.endsWithParent||z(e.starts))}function U(e){const n={props:["language","code","autodetect"],data:function(){return{detectedLanguage:"",unknownLanguage:!1}},computed:{className(){return this.unknownLanguage?"":"hljs "+this.detectedLanguage},highlighted(){if(!this.autoDetect&&!e.getLanguage(this.language))return console.warn(`The language "${this.language}" you specified could not be found.`),this.unknownLanguage=!0,s(this.code);let n={};return this.autoDetect?(n=e.highlightAuto(this.code),this.detectedLanguage=n.language):(n=e.highlight(this.language,this.code,this.ignoreIllegals),this.detectedLanguage=this.language),n.value},autoDetect(){return!this.language||(e=this.autodetect,Boolean(e||""===e));var e},ignoreIllegals:()=>!0},render(e){return e("pre",{},[e("code",{class:this.className,domProps:{innerHTML:this.highlighted}})])}};return{Component:n,VuePlugin:{install(e){e.component("highlightjs",n)}}}}const W={"after:highlightBlock":({block:e,result:n,text:t})=>{const a=G(e);if(!a.length)return;const i=document.createElement("div");i.innerHTML=n.value,n.value=function(e,n,t){let a=0,i="";const r=[];function o(){return e.length&&n.length?e[0].offset!==n[0].offset?e[0].offset<n[0].offset?e:n:"start"===n[0].event?e:n:e.length?e:n}function l(e){i+="<"+K(e)+[].map.call(e.attributes,(function(e){return" "+e.nodeName+'="'+s(e.value)+'"'})).join("")+">"}function c(e){i+="</"+K(e)+">"}function u(e){("start"===e.event?l:c)(e.node)}for(;e.length||n.length;){let n=o();if(i+=s(t.substring(a,n[0].offset)),a=n[0].offset,n===e){r.reverse().forEach(c);do{u(n.splice(0,1)[0]),n=o()}while(n===e&&n.length&&n[0].offset===a);r.reverse().forEach(l)}else"start"===n[0].event?r.push(n[0].node):r.pop(),u(n.splice(0,1)[0])}return i+s(t.substr(a))}(a,G(i),t)}};function K(e){return e.nodeName.toLowerCase()}function G(e){const n=[];return function e(t,a){for(let i=t.firstChild;i;i=i.nextSibling)3===i.nodeType?a+=i.nodeValue.length:1===i.nodeType&&(n.push({event:"start",offset:a,node:i}),a=e(i,a),K(i).match(/br|hr|img|input/)||n.push({event:"stop",offset:a,node:i}));return a}(e,0),n}const F=e=>{console.error(e)},Q=(e,...n)=>{console.log(`WARN: ${e}`,...n)},Z=(e,n)=>{console.log(`Deprecated as of ${e}. ${n}`)},V=s,X=r,Y=Symbol("nomatch");var J=function(e){const n=Object.create(null),a=Object.create(null),s=[];let r=!0;const o=/(^(<[^>]+>|\t|)+|\n)/gm,l="Could not find the language '{}', did you forget to load/include a language module?",c={disableAutodetect:!0,name:"Plain text",contains:[]};let g={noHighlightRe:/^(no-?highlight)$/i,languageDetectRe:/\blang(?:uage)?-([\w-]+)\b/i,classPrefix:"hljs-",tabReplace:null,useBR:!1,languages:null,__emitter:u};function d(e){return g.noHighlightRe.test(e)}function h(e,n,t,a){const i={code:n,language:e};L("before:highlight",i);const s=i.result?i.result:f(i.language,i.code,t,a);return s.code=i.code,L("after:highlight",s),s}function f(e,t,a,o){const c=t;function u(e,n){const t=x.case_insensitive?n[0].toLowerCase():n[0];return Object.prototype.hasOwnProperty.call(e.keywords,t)&&e.keywords[t]}function d(){null!=R.subLanguage?function(){if(""===k)return;let e=null;if("string"==typeof R.subLanguage){if(!n[R.subLanguage])return void L.addText(k);e=f(R.subLanguage,k,!0,A[R.subLanguage]),A[R.subLanguage]=e.top}else e=b(k,R.subLanguage.length?R.subLanguage:null);R.relevance>0&&(M+=e.relevance),L.addSublanguage(e.emitter,e.language)}():function(){if(!R.keywords)return void L.addText(k);let e=0;R.keywordPatternRe.lastIndex=0;let n=R.keywordPatternRe.exec(k),t="";for(;n;){t+=k.substring(e,n.index);const a=u(R,n);if(a){const[e,i]=a;L.addText(t),t="",M+=i;const s=x.classNameAliases[e]||e;L.addKeyword(n[0],s)}else t+=n[0];e=R.keywordPatternRe.lastIndex,n=R.keywordPatternRe.exec(k)}t+=k.substr(e),L.addText(t)}(),k=""}function h(e){return e.className&&L.openNode(x.classNameAliases[e.className]||e.className),R=Object.create(e,{parent:{value:R}}),R}function m(e,n,t){let a=function(e,n){const t=e&&e.exec(n);return t&&0===t.index}(e.endRe,t);if(a){if(e["on:end"]){const t=new i(e);e["on:end"](n,t),t.ignore&&(a=!1)}if(a){for(;e.endsParent&&e.parent;)e=e.parent;return e}}if(e.endsWithParent)return m(e.parent,n,t)}function p(e){return 0===R.matcher.regexIndex?(k+=e[0],1):(B=!0,0)}function E(e){const n=e[0],t=c.substr(e.index),a=m(R,e,t);if(!a)return Y;const i=R;i.skip?k+=n:(i.returnEnd||i.excludeEnd||(k+=n),d(),i.excludeEnd&&(k=n));do{R.className&&L.closeNode(),R.skip||R.subLanguage||(M+=R.relevance),R=R.parent}while(R!==a.parent);return a.starts&&(a.endSameAsBegin&&(a.starts.endRe=a.endRe),h(a.starts)),i.returnEnd?0:n.length}let v={};function w(n,t){const s=t&&t[0];if(k+=n,null==s)return d(),0;if("begin"===v.type&&"end"===t.type&&v.index===t.index&&""===s){if(k+=c.slice(t.index,t.index+1),!r){const n=new Error("0 width match regex");throw n.languageName=e,n.badRule=v.rule,n}return 1}if(v=t,"begin"===t.type)return function(e){const n=e[0],t=e.rule,a=new i(t),s=[t.__beforeBegin,t["on:begin"]];for(const t of s)if(t&&(t(e,a),a.ignore))return p(n);return t&&t.endSameAsBegin&&(t.endRe=new RegExp(n.replace(/[-/\\^$*+?.()|[\]{}]/g,"\\$&"),"m")),t.skip?k+=n:(t.excludeBegin&&(k+=n),d(),t.returnBegin||t.excludeBegin||(k=n)),h(t),t.returnBegin?0:n.length}(t);if("illegal"===t.type&&!a){const e=new Error('Illegal lexeme "'+s+'" for mode "'+(R.className||"<unnamed>")+'"');throw e.mode=R,e}if("end"===t.type){const e=E(t);if(e!==Y)return e}if("illegal"===t.type&&""===s)return 1;if(O>1e5&&O>3*t.index)throw new Error("potential infinite loop, way more iterations than matches");return k+=s,s.length}const x=y(e);if(!x)throw F(l.replace("{}",e)),new Error('Unknown language: "'+e+'"');const N=q(x,{plugins:s});let _="",R=o||N;const A={},L=new g.__emitter(g);!function(){const e=[];for(let n=R;n!==x;n=n.parent)n.className&&e.unshift(n.className);e.forEach((e=>L.openNode(e)))}();let k="",M=0,S=0,O=0,B=!1;try{for(R.matcher.considerAll();;){O++,B?B=!1:R.matcher.considerAll(),R.matcher.lastIndex=S;const e=R.matcher.exec(c);if(!e)break;const n=w(c.substring(S,e.index),e);S=e.index+n}return w(c.substr(S)),L.closeAllNodes(),L.finalize(),_=L.toHTML(),{relevance:Math.floor(M),value:_,language:e,illegal:!1,emitter:L,top:R}}catch(n){if(n.message&&n.message.includes("Illegal"))return{illegal:!0,illegalBy:{msg:n.message,context:c.slice(S-100,S+100),mode:n.mode},sofar:_,relevance:0,value:V(c),emitter:L};if(r)return{illegal:!1,relevance:0,value:V(c),emitter:L,language:e,top:R,errorRaised:n};throw n}}function b(e,t){t=t||g.languages||Object.keys(n);const a=function(e){const n={relevance:0,emitter:new g.__emitter(g),value:V(e),illegal:!1,top:c};return n.emitter.addText(e),n}(e),i=t.filter(y).filter(A).map((n=>f(n,e,!1)));i.unshift(a);const s=i.sort(((e,n)=>{if(e.relevance!==n.relevance)return n.relevance-e.relevance;if(e.language&&n.language){if(y(e.language).supersetOf===n.language)return 1;if(y(n.language).supersetOf===e.language)return-1}return 0})),[r,o]=s,l=r;return l.second_best=o,l}const m={"before:highlightBlock":({block:e})=>{g.useBR&&(e.innerHTML=e.innerHTML.replace(/\n/g,"").replace(/<br[ /]*>/g,"\n"))},"after:highlightBlock":({result:e})=>{g.useBR&&(e.value=e.value.replace(/\n/g,"<br>"))}},p=/^(<[^>]+>|\t)+/gm,E={"after:highlightBlock":({result:e})=>{g.tabReplace&&(e.value=e.value.replace(p,(e=>e.replace(/\t/g,g.tabReplace))))}};function v(e){let n=null;const t=function(e){let n=e.className+" ";n+=e.parentNode?e.parentNode.className:"";const t=g.languageDetectRe.exec(n);if(t){const n=y(t[1]);return n||(Q(l.replace("{}",t[1])),Q("Falling back to no-highlight mode for this block.",e)),n?t[1]:"no-highlight"}return n.split(/\s+/).find((e=>d(e)||y(e)))}(e);if(d(t))return;L("before:highlightBlock",{block:e,language:t}),n=e;const i=n.textContent,s=t?h(t,i,!0):b(i);L("after:highlightBlock",{block:e,result:s,text:i}),e.innerHTML=s.value,function(e,n,t){const i=n?a[n]:t;e.classList.add("hljs"),i&&e.classList.add(i)}(e,t,s.language),e.result={language:s.language,re:s.relevance,relavance:s.relevance},s.second_best&&(e.second_best={language:s.second_best.language,re:s.second_best.relevance,relavance:s.second_best.relevance})}const w=()=>{w.called||(w.called=!0,Z("10.6.0","initHighlighting() is deprecated.  Use highlightAll() instead."),document.querySelectorAll("pre code").forEach(v))};let x=!1,N=!1;function _(){N?document.querySelectorAll("pre code").forEach(v):x=!0}function y(e){return e=(e||"").toLowerCase(),n[e]||n[a[e]]}function R(e,{languageName:n}){"string"==typeof e&&(e=[e]),e.forEach((e=>{a[e]=n}))}function A(e){const n=y(e);return n&&!n.disableAutodetect}function L(e,n){const t=e;s.forEach((function(e){e[t]&&e[t](n)}))}"undefined"!=typeof window&&window.addEventListener&&window.addEventListener("DOMContentLoaded",(function(){N=!0,x&&_()}),!1),Object.assign(e,{highlight:h,highlightAuto:b,highlightAll:_,fixMarkup:function(e){return Z("10.2.0","fixMarkup will be removed entirely in v11.0"),Z("10.2.0","Please see https://github.com/highlightjs/highlight.js/issues/2534"),n=e,g.tabReplace||g.useBR?n.replace(o,(e=>"\n"===e?g.useBR?"<br>":e:g.tabReplace?e.replace(/\t/g,g.tabReplace):e)):n;var n},highlightBlock:v,configure:function(e){e.useBR&&(Z("10.3.0","'useBR' will be removed entirely in v11.0"),Z("10.3.0","Please see https://github.com/highlightjs/highlight.js/issues/2559")),g=X(g,e)},initHighlighting:w,initHighlightingOnLoad:function(){Z("10.6.0","initHighlightingOnLoad() is deprecated.  Use highlightAll() instead."),x=!0},registerLanguage:function(t,a){let i=null;try{i=a(e)}catch(e){if(F("Language definition for '{}' could not be registered.".replace("{}",t)),!r)throw e;F(e),i=c}i.name||(i.name=t),n[t]=i,i.rawDefinition=a.bind(null,e),i.aliases&&R(i.aliases,{languageName:t})},listLanguages:function(){return Object.keys(n)},getLanguage:y,registerAliases:R,requireLanguage:function(e){Z("10.4.0","requireLanguage will be removed entirely in v11."),Z("10.4.0","Please see https://github.com/highlightjs/highlight.js/pull/2844");const n=y(e);if(n)return n;throw new Error("The '{}' language is required, but not loaded.".replace("{}",e))},autoDetection:A,inherit:X,addPlugin:function(e){s.push(e)},vuePlugin:U(e).VuePlugin}),e.debugMode=function(){r=!1},e.safeMode=function(){r=!0},e.versionString="10.6.0";for(const e in B)"object"==typeof B[e]&&t(B[e]);return Object.assign(e,B),e.addPlugin(m),e.addPlugin(W),e.addPlugin(E),e}({});e.exports=J},473:e=>{function n(...e){return e.map((e=>{return(n=e)?"string"==typeof n?n:n.source:null;var n})).join("")}e.exports=function(e){const t="([a-zA-Z_]\\w*[!?=]?|[-+~]@|<<|>>|=~|===?|<=>|[<>]=?|\\*\\*|[-/+%^&*~`|]|\\[\\]=?)",a={keyword:"and then defined module in return redo if BEGIN retry end for self when next until do begin unless END rescue else break undef not super class case require yield alias while ensure elsif or include attr_reader attr_writer attr_accessor __FILE__",built_in:"proc lambda",literal:"true false nil"},i={className:"doctag",begin:"@[A-Za-z]+"},s={begin:"#<",end:">"},r=[e.COMMENT("#","$",{contains:[i]}),e.COMMENT("^=begin","^=end",{contains:[i],relevance:10}),e.COMMENT("^__END__","\\n$")],o={className:"subst",begin:/#\{/,end:/\}/,keywords:a},l={className:"string",contains:[e.BACKSLASH_ESCAPE,o],variants:[{begin:/'/,end:/'/},{begin:/"/,end:/"/},{begin:/`/,end:/`/},{begin:/%[qQwWx]?\(/,end:/\)/},{begin:/%[qQwWx]?\[/,end:/\]/},{begin:/%[qQwWx]?\{/,end:/\}/},{begin:/%[qQwWx]?</,end:/>/},{begin:/%[qQwWx]?\//,end:/\//},{begin:/%[qQwWx]?%/,end:/%/},{begin:/%[qQwWx]?-/,end:/-/},{begin:/%[qQwWx]?\|/,end:/\|/},{begin:/\B\?(\\\d{1,3})/},{begin:/\B\?(\\x[A-Fa-f0-9]{1,2})/},{begin:/\B\?(\\u\{?[A-Fa-f0-9]{1,6}\}?)/},{begin:/\B\?(\\M-\\C-|\\M-\\c|\\c\\M-|\\M-|\\C-\\M-)[\x20-\x7e]/},{begin:/\B\?\\(c|C-)[\x20-\x7e]/},{begin:/\B\?\\?\S/},{begin:/<<[-~]?'?(\w+)\n(?:[^\n]*\n)*?\s*\1\b/,returnBegin:!0,contains:[{begin:/<<[-~]?'?/},e.END_SAME_AS_BEGIN({begin:/(\w+)/,end:/(\w+)/,contains:[e.BACKSLASH_ESCAPE,o]})]}]},c="[0-9](_?[0-9])*",u={className:"number",relevance:0,variants:[{begin:`\\b([1-9](_?[0-9])*|0)(\\.(${c}))?([eE][+-]?(${c})|r)?i?\\b`},{begin:"\\b0[dD][0-9](_?[0-9])*r?i?\\b"},{begin:"\\b0[bB][0-1](_?[0-1])*r?i?\\b"},{begin:"\\b0[oO][0-7](_?[0-7])*r?i?\\b"},{begin:"\\b0[xX][0-9a-fA-F](_?[0-9a-fA-F])*r?i?\\b"},{begin:"\\b0(_?[0-7])+r?i?\\b"}]},g={className:"params",begin:"\\(",end:"\\)",endsParent:!0,keywords:a},d=[l,{className:"class",beginKeywords:"class module",end:"$|;",illegal:/=/,contains:[e.inherit(e.TITLE_MODE,{begin:"[A-Za-z_]\\w*(::\\w+)*(\\?|!)?"}),{begin:"<\\s*",contains:[{begin:"("+e.IDENT_RE+"::)?"+e.IDENT_RE,relevance:0}]}].concat(r)},{className:"function",begin:n(/def\s*/,(h=t+"\\s*(\\(|;|$)",n("(?=",h,")"))),relevance:0,keywords:"def",end:"$|;",contains:[e.inherit(e.TITLE_MODE,{begin:t}),g].concat(r)},{begin:e.IDENT_RE+"::"},{className:"symbol",begin:e.UNDERSCORE_IDENT_RE+"(!|\\?)?:",relevance:0},{className:"symbol",begin:":(?!\\s)",contains:[l,{begin:t}],relevance:0},u,{className:"variable",begin:"(\\$\\W)|((\\$|@@?)(\\w+))(?=[^@$?])(?![A-Za-z])(?![@$?'])"},{className:"params",begin:/\|/,end:/\|/,relevance:0,keywords:a},{begin:"("+e.RE_STARTERS_RE+"|unless)\\s*",keywords:"unless",contains:[{className:"regexp",contains:[e.BACKSLASH_ESCAPE,o],illegal:/\n/,variants:[{begin:"/",end:"/[a-z]*"},{begin:/%r\{/,end:/\}[a-z]*/},{begin:"%r\\(",end:"\\)[a-z]*"},{begin:"%r!",end:"![a-z]*"},{begin:"%r\\[",end:"\\][a-z]*"}]}].concat(s,r),relevance:0}].concat(s,r);var h;o.contains=d,g.contains=d;const f=[{begin:/^\s*=>/,starts:{end:"$",contains:d}},{className:"meta",begin:"^([>?]>|[\\w#]+\\(\\w+\\):\\d+:\\d+>|(\\w+-)?\\d+\\.\\d+\\.\\d+(p\\d+)?[^\\d][^>]+>)(?=[ ])",starts:{end:"$",contains:d}}];return r.unshift(s),{name:"Ruby",aliases:["rb","gemspec","podspec","thor","irb"],keywords:a,illegal:/\/\*/,contains:[e.SHEBANG({binary:"ruby"})].concat(f).concat(r).concat(d)}}},514:e=>{e.exports=function(e){return{name:"Shell Session",aliases:["console"],contains:[{className:"meta",begin:/^\s{0,3}[/~\w\d[\]()@-]*[>%$#]/,starts:{end:/[^\\](?=\s*$)/,subLanguage:"bash"}}]}}},587:e=>{e.exports=function(e){var n="true false yes no null",t="[\\w#;/?:@&=+$,.~*'()[\\]]+",a={className:"string",relevance:0,variants:[{begin:/'/,end:/'/},{begin:/"/,end:/"/},{begin:/\S+/}],contains:[e.BACKSLASH_ESCAPE,{className:"template-variable",variants:[{begin:/\{\{/,end:/\}\}/},{begin:/%\{/,end:/\}/}]}]},i=e.inherit(a,{variants:[{begin:/'/,end:/'/},{begin:/"/,end:/"/},{begin:/[^\s,{}[\]]+/}]}),s={end:",",endsWithParent:!0,excludeEnd:!0,keywords:n,relevance:0},r={begin:/\{/,end:/\}/,contains:[s],illegal:"\\n",relevance:0},o={begin:"\\[",end:"\\]",contains:[s],illegal:"\\n",relevance:0},l=[{className:"attr",variants:[{begin:"\\w[\\w :\\/.-]*:(?=[ \t]|$)"},{begin:'"\\w[\\w :\\/.-]*":(?=[ \t]|$)'},{begin:"'\\w[\\w :\\/.-]*':(?=[ \t]|$)"}]},{className:"meta",begin:"^---\\s*$",relevance:10},{className:"string",begin:"[\\|>]([1-9]?[+-])?[ ]*\\n( +)[^ ][^\\n]*\\n(\\2[^\\n]+\\n?)*"},{begin:"<%[%=-]?",end:"[%-]?%>",subLanguage:"ruby",excludeBegin:!0,excludeEnd:!0,relevance:0},{className:"type",begin:"!\\w+!"+t},{className:"type",begin:"!<"+t+">"},{className:"type",begin:"!"+t},{className:"type",begin:"!!"+t},{className:"meta",begin:"&"+e.UNDERSCORE_IDENT_RE+"$"},{className:"meta",begin:"\\*"+e.UNDERSCORE_IDENT_RE+"$"},{className:"bullet",begin:"-(?=[ ]|$)",relevance:0},e.HASH_COMMENT_MODE,{beginKeywords:n,keywords:{literal:n}},{className:"number",begin:"\\b[0-9]{4}(-[0-9][0-9]){0,2}([Tt \\t][0-9][0-9]?(:[0-9][0-9]){2})?(\\.[0-9]*)?([ \\t])*(Z|[-+][0-9][0-9]?(:[0-9][0-9])?)?\\b"},{className:"number",begin:e.C_NUMBER_RE+"\\b",relevance:0},r,o,a],c=[...l];return c.pop(),c.push(i),s.contains=c,{name:"YAML",case_insensitive:!0,aliases:["yml","YAML"],contains:l}}}},n={};function t(a){if(n[a])return n[a].exports;var i=n[a]={exports:{}};return e[a](i,i.exports,t),i.exports}t.n=e=>{var n=e&&e.__esModule?()=>e.default:()=>e;return t.d(n,{a:n}),n},t.d=(e,n)=>{for(var a in n)t.o(n,a)&&!t.o(e,a)&&Object.defineProperty(e,a,{enumerable:!0,get:n[a]})},t.o=(e,n)=>Object.prototype.hasOwnProperty.call(e,n),(()=>{"use strict";var e=t(802),n=t.n(e),a=t(473),i=t.n(a),s=t(587),r=t.n(s),o=t(514),l=t.n(o);n().registerLanguage("ruby",i()),n().registerLanguage("yaml",r()),n().registerLanguage("shell",l()),document.addEventListener("DOMContentLoaded",(e=>{document.querySelectorAll("pre code").forEach((e=>{n().highlightBlock(e)})),document.querySelectorAll(".tab").forEach((e=>{e.addEventListener("click",(function(){document.querySelectorAll(".tab-content").forEach((e=>e.classList.remove("active"))),document.querySelectorAll(".tab").forEach((e=>e.classList.remove("active")));const e=document.querySelector(this.getAttribute("data-href"));e&&e.classList.add("active"),this.classList.add("active")}))}));var t=localStorage.getItem("theme"),a=window.matchMedia("(prefers-color-scheme: dark)"),i=document.querySelectorAll("#toggle-dark"),s=document.querySelectorAll("#toggle-light"),r=document.querySelector("html");"dark"===t||!t&&a.matches?(r.classList.add("dark"),i.forEach((e=>e.classList.add("visible"))),s.forEach((e=>e.classList.remove("hidden")))):(s.forEach((e=>e.classList.add("visible"))),i.forEach((e=>e.classList.remove("hidden")))),s.forEach((e=>{e.addEventListener("click",(function(){localStorage.setItem("theme","light"),r.classList.remove("dark"),i.forEach((e=>e.classList.add("visible"))),i.forEach((e=>e.classList.remove("hidden"))),s.forEach((e=>e.classList.add("hidden"))),s.forEach((e=>e.classList.remove("visible")))}))})),i.forEach((e=>{e.addEventListener("click",(function(){localStorage.setItem("theme","dark"),r.classList.add("dark"),s.forEach((e=>e.classList.add("visible"))),s.forEach((e=>e.classList.remove("hidden"))),i.forEach((e=>e.classList.add("hidden"))),i.forEach((e=>e.classList.remove("visible")))}))}))}))})()})();