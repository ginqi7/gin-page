export default function (eleventyConfig) {
  // copy static files to output directory.
  eleventyConfig.addPassthroughCopy("assets/*");
  eleventyConfig.addPassthroughCopy("assets/**/*");
  eleventyConfig.addPassthroughCopy("*.png");

  var createbookBase = "/";
  if (process.env.CREATEBOOK_BASE) {
    createbookBase = process.env.CREATEBOOK_BASE;
  }

  eleventyConfig.addGlobalData("createbookBase", createbookBase);
}
