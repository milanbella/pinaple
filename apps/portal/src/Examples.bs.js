// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");

function $$default(props) {
  return React.createElement("div", undefined, props.msg, React.createElement("a", {
                  href: props.href,
                  target: "_blank"
                }, "`src/Examples.res`"));
}

function getServerSideProps(_ctx) {
  return Promise.resolve({
              props: {
                msg: "This page was rendered with getServerSideProps. You can find the source code here: ",
                href: "https://github.com/ryyppy/nextjs-default/tree/master/src/Examples.res"
              }
            });
}

exports.$$default = $$default;
exports.default = $$default;
exports.__esModule = true;
exports.getServerSideProps = getServerSideProps;
/* react Not a pure module */
