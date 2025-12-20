export default function (eleventyConfig) {
  // copy static files to output directory.
  eleventyConfig.addPassthroughCopy("assets/*");
  eleventyConfig.addPassthroughCopy("assets/**/*");
  eleventyConfig.addPassthroughCopy("*.png");
  eleventyConfig.addPassthroughCopy("CNAME");
  eleventyConfig.addGlobalData("currentYear", new Date().getFullYear());
}
