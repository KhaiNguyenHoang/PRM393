using System.ComponentModel;

namespace Netmu.Dtos;

public class PaginationParam
{
    private int _page = 1;
    private int _size = 10;

    [Description("Current page number (positive integer)")]
    public int Page
    {
        get => _page;
        set => _page = value < 1 ? 1 : value;
    }

    [Description("Page size (positive integer)")]
    public int Size
    {
        get => _size;
        set => _size = value < 1 ? 10 : value;
    }
}

public class PaginationMetadata
{
    public bool HasNextPage { get; set; }
    public bool HasPreviousPage { get; set; }
    public int TotalItemCount { get; set; }
    public int PageCount { get; set; }
    public int CurrentPage { get; set; }
    public int PageSize { get; set; }
}

public class Pagination<T>(PaginationMetadata metadata, IEnumerable<T> items) where T : class
{
    public PaginationMetadata Metadata { get; set; } = metadata;
    public IEnumerable<T> Items { get; set; } = items;
}