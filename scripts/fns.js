const fs = require('fs');

const template = (tag) => `
${tag} :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
${tag} = mkTagFn "${tag.replace('_', '')}"
`;

fs.readFile('tags.txt', (err, data) => {
  const tags = String(data).split("\n");

  tags.forEach(tag => {
    console.log(template(tag));
  });
});
