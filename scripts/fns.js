const fs = require('fs');

const template = (tag) => `
${tag} :: forall body msg. BodyAble body msg => Array (Attribute msg) -> body -> View msg
${tag} = mkTagFn "${tag.replace('_', '')}"
`;

fs.readFile('scripts/tags.txt', (err, data) => {
  const tags = String(data).split("\n");

  tags.forEach(tag => {
    console.log(template(tag));
  });
});
